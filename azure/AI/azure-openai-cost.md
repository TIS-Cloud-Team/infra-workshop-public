- https://medium.com/devrain/calculating-azure-openai-service-usage-costs-a-comprehensive-guide-40b0880660f9#:~:text=In%20addition%20to%20language%20and%20image%20models%2C%20Azure,embedding%20model%2C%20Ada%2C%20is%20%240.0001%20per%201%2C000%20tokens.
- **model benchmarks:** https://learn.microsoft.com/en-us/azure/ai-studio/how-to/model-benchmarks
- **azure ai studio**: https://learn.microsoft.com/en-us/azure/ai-studio/
- **plan and manage cost**: https://learn.microsoft.com/en-us/azure/ai-studio/how-to/costs-plan-manage
- **quotas**: https://learn.microsoft.com/en-us/azure/ai-studio/how-to/quota
- **rate limit**: https://learn.microsoft.com/en-us/azure/ai-studio/how-to/autoscale?tabs=portal


# Calculating Azure OpenAI Service Usage Costs: A Comprehensive Guide


![](https://miro.medium.com/v2/resize:fit:1400/1*d89_hEw6445qVlVVwcmXkA.png)

Tokenizer tool

[Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/overview) is a powerful cloud service offered by Microsoft Azure, enabling developers to leverage OpenAI’s state-of-the-art language models. With a range of models available, including  *gpt-3.5-turbo, gpt-4, DALL-E* , and  *ada* , developers can unlock new possibilities in content generation, summarization, semantic search, and even natural language to code translation. In this blog post, we will explore the capabilities of Azure OpenAI Service and delve into its pricing structure.

# Tokens

From [OpenAI help center](https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them#h_63fd902129):

Tokens can be thought of as pieces of words. Before the API processes the prompts, the input is broken down into tokens. These tokens are not cut up exactly where the words start or end — tokens can include trailing spaces and even sub-words. Here are some helpful rules of thumb for understanding tokens in terms of lengths:

* 1 token ~= 4 chars in English
* 1 token ~= ¾ words
* 100 tokens ~= 75 words

Or

* 1–2 sentence ~= 30 tokens
* 1 paragraph ~= 100 tokens
* 1,500 words ~= 2048 tokens

To get additional context on how tokens stack up, consider this:

* Wayne Gretzky’s quote “You miss 100% of the shots you don’t take” contains 11 tokens.
* OpenAI’s [charter](https://openai.com/charter/) contains 476 tokens.
* The transcript of the US Declaration of Independence contains 1,695 tokens.

How words are split into tokens is also language-dependent. For example, ‘Cómo estás’ (‘How are you’ in Spanish) contains 5 tokens (for 10 chars). The higher token-to-char ratio can make it more expensive to implement the API for languages other than English.

To further explore tokenization, you can use our interactive [Tokenizer tool](https://beta.openai.com/tokenizer), which allows you to calculate the number of tokens and see how text is broken into tokens. Alternatively, if you’d like to tokenize text programmatically, use [Tiktoken](https://github.com/openai/tiktoken) as a fast BPE tokenizer specifically used for OpenAI models. Other such libraries you can explore as well include [transformers](https://huggingface.co/transformers/model_doc/gpt2.html#gpt2tokenizerfast) package for Python or the [gpt-3-encoder](https://www.npmjs.com/package/gpt-3-encoder) package for node.js.

Depending on the [model](https://beta.openai.com/docs/engines/gpt-3) used, requests can use up to 4,097 tokens shared between prompt and completion. If your prompt is 4,000 tokens, your completion can be 97 tokens at most.

# GPT-3.5 models

The current version of *gpt-3.5-turbo *has limit of 4,096 tokens, while the latest version of *gpt-3.5-turbo-16k *has a limit of 16,384 tokens. Both are priced at  **$0.002 per 1,000 tokens ** (the same price for *prompt *and  *completion* ).

# GPT-4 models

GPT-4 models are available in two options: *gpt-4 *model with a limit of
8,192 tokens and *gpt-4–32k *with a limit of 32,768 tokens.

The pricing for the *gpt-4 *model in *prompt *mode is **$0.03 for an 8K context **and  **$0.06 for a 32K context per 1,000 tokens** . In *completion *mode, the pricing is **$0.06 for an 8K context **and  **$0.12 for a 32K context per 1,000 tokens** .

# Fine-tuned models

Only GPT-3 models (ada, curie, davinci, babbage) are available for fine-tuning (they are called “base” models).

From [Microsoft Learn](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/how-to/manage-costs):

Azure OpenAI fine-tuned models are charged based on three factors:

* Training hours
* Hosting hours
* Inference per 1,000 tokens

The hosting hours cost is important to be aware of since once a fine-tuned model is deployed it continues to incur an hourly cost regardless of whether you’re actively using it. Fine-tuned model costs should be monitored closely.

> As for now, fine-tuned models are not available in Azure OpenAI Service.

# DALL-E

Azure OpenAI Service also includes image models, with pricing based on the number of images processed. The standard image model, DALL-E, is priced as  **$2 per 100 images** .

# **Embedding model**

In addition to language and image models, Azure OpenAI Service offers embedding model. The pricing for the standard embedding model, Ada, is  **$0.0001 per 1,000 tokens** .

# Pricing calculation example

Imagine, we need to make the following requests:

* 1,000 tokens in prompt and 1,000 tokens in completion with *gpt-3.5-turbo *model;
* 1,000 tokens in prompt and 1,000 tokens in completion with *gpt-4 *model;
* 30,000 tokens in prompt and 10,000 tokens in completion with *gpt-4–32k *model.

Calculation logic:

For *gpt-3.5-turbo *the cost would be:
(1,000 +1,000) / 1,000 * $0.002 = 2 * $0.002 = $0.004.

For *gpt-4 *the cost will be:
(1,000 / 1,000 * $0.03) + (1,000 / 1,000 * $0.06) = $0.03 + $0.06 = $0.09.

For *gpt-4–32k *the cost will be:
(30,000 / 1,000 * $0.06) + (10,000 / 1,000 * $0.12) = 30 * $0.06 + 10 * $0.12 = $1.8 + $1.2 = $3

In total, the price will be $3.094.

As you can see from the example, using gpt-4-32k is expensive while *gpt-3.5-turbo *is the most cost-saving option.

—

You can use [Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/) to calculate your workloads with Azure OpenAI, but GPT-4 and fine-tuned models are currently missing from it.

Azure OpenAI Service runs on Azure infrastructure that accrues costs when you deploy new resources. It’s important to understand that there could be other additional infrastructure costs that might accrue.

Keep in mind that enabling capabilities like sending data to Azure Monitor Logs, alerting, etc. incurs additional costs for those services. These costs are visible under those other services and at the subscription level, but aren’t visible when scoped just to your Azure OpenAI resource.
