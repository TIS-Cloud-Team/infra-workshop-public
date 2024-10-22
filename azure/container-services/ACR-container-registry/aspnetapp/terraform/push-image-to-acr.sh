## get ACR login server, username and password
ACR_LOGIN_SERVER=$(terraform output -raw acr_login_server)
ACR_USERNAME=$(terraform output -raw acr_admin_username)
ACR_PASSWORD=$(terraform output -raw acr_admin_password)
ACR_NAME=$(terraform output -raw acr_name)

## image name
MYIMAGENAME="workshop-dotnetapp:latest"

## login to ACR
docker login $ACR_LOGIN_SERVER -u $ACR_USERNAME -p $ACR_PASSWORD

## tag local image with ACR login server
docker tag $MYIMAGENAME $ACR_LOGIN_SERVER/$MYIMAGENAME

## push image to ACR
docker push $ACR_LOGIN_SERVER/$MYIMAGENAME

# List all repositories in the ACR
repositories=$(az acr repository list --name $ACR_NAME --output tsv)

# Loop through each repository and list tags, sizes, platforms, and dates
for repo in $repositories; do
  echo "Repository: $repo"
  
  # List all tags in the repository
  tags=$(az acr repository show-tags --name $ACR_NAME --repository $repo --output tsv)
  
  for tag in $tags; do
    echo "  Tag: $tag"
    
    # Get manifest details for each tag
    manifest=$(az acr repository show-manifests --name $ACR_NAME --repository $repo --query "[?tags[?contains(@, '$tag')]].{Digest:digest,Size:size,Platform:architecture,Date:createdTime}" --output table)
    
    echo "$manifest"
  done
done

## logout from ACR
docker logout $ACR_LOGIN_SERVER

