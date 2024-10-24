resource "aws_s3_bucket" "website_bucket" {
  bucket = "s3-bucket-${local.app_name}-123456"

  website {
    index_document = "index.html"
  }

  tags = merge(
    {
      Name = "s3-bucket-${local.app_name}"
    },
    local.global_tags
  )
}

resource "aws_s3_bucket_ownership_controls" "s3-ownership_controls" {
  bucket = aws_s3_bucket.website_bucket.bucket

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}","${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}

resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "aws_cloudfront_origin_access_identity for ${local.app_name}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront for ${local.app_name}"
  default_root_object = "index.html"
  ##aliases             = ["<my-app-name>.cloudfront.net"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.website_bucket.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0 ##3600
    max_ttl                = 0 ##86400
  }

  # ordered_cache_behavior {
  #   path_pattern     = "/index.html"
  #   allowed_methods  = ["GET", "HEAD", "OPTIONS"]
  #   cached_methods   = ["GET", "HEAD", "OPTIONS"]
  #   target_origin_id = aws_s3_bucket.website_bucket.id

  #   forwarded_values {
  #     query_string = false
  #     headers      = ["*"]

  #     cookies {
  #       forward = "none"
  #     }
  #   }

  #   min_ttl                = 0
  #   default_ttl            = 0
  #   max_ttl                = 0
  #   compress               = true
  #   viewer_protocol_policy = "redirect-to-https"
  # }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    ##acm_certificate_arn      = aws_acm_certificate.cert.arn
    ##ssl_support_method       = "sni-only"
    ##minimum_protocol_version = "TLSv1.2_2018"
  }
}

## create sqs queue
resource "aws_sqs_queue" "s3_event_queue" {
  name = local.s3_event_queue_name
  visibility_timeout_seconds = 300
  message_retention_seconds = 86400
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.website_bucket.id

  queue {
    queue_arn     = aws_sqs_queue.s3_event_queue.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".pdf"
  }
}

resource "aws_sqs_queue_policy" "s3_event_queue_policy" {
  queue_url = aws_sqs_queue.s3_event_queue.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "Allow-S3-events",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.s3_event_queue.arn}",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "${aws_s3_bucket.website_bucket.arn}"
        }
      }
    }
  ]
}
POLICY
}

## 
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.s3_distribution.domain_name
}