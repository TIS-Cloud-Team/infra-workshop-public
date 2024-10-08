#!/bin/bash

# Variables
GITHUB_HOST="your_github_enterprise_host" ## https://docs.github.com/en/enterprise-server@latest/admin/installation/configuring-the-server-address
REPO_OWNER="your_repo_owner"
REPO_NAME="your_repo_name"
PAT="your_personal_access_token"  ## https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

# Function to get issues
## https://docs.github.com/en/rest/reference/issues
get_issues() {
  curl -s -H "Authorization: token $PAT" \
       -H "Accept: application/vnd.github.v3+json" \
       "https://$GITHUB_HOST/api/v3/repos/$REPO_OWNER/$REPO_NAME/issues"
}

# Function to get projects
## https://docs.github.com/en/rest/reference/projects
get_projects() {
  curl -s -H "Authorization: token $PAT" \
       -H "Accept: application/vnd.github.inertia-preview+json" \
       "https://$GITHUB_HOST/api/v3/repos/$REPO_OWNER/$REPO_NAME/projects"
}

# Get issues and projects
echo "Fetching issues..."
issues=$(get_issues)
echo "Issues: $issues"

echo "Fetching projects..."
projects=$(get_projects)
echo "Projects: $projects"