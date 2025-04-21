#!/usr/bin/bash

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Git deployment script for SN Fish and Chips
deploy_to_github() {
    # Ensure the user is on the master branch before deploying
    current_branch=$(git rev-parse --abbrev-ref HEAD)

    if [ "$current_branch" != "master" ]; then
        echo -e "${YELLOW}Switching to master bracnh...${NC}"
        git checkout master 2>/dev/null || git checkout -b master
    fi

    # Add all changes
    git add .

    # prompt for a commit
    read -p "Enter commit message: " commit_message

    # Commit Changes
    git commit -m "$commit_message"

    # Push to master GitHub
    git push origin master
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to push to Github.${NC}"
        exit 1
    fi

    echo -e "${GREEN}Changes pushed to GitHub successfully!${NC}"

    # Check if gh-pages branch exists
    if git show-ref --quiet refs/heads/gh-pages; then
        echo -e "${GREEN}gh-pages branch exists. Updating...${NC}"
        git checkout gh-pages
        git merge master --no-edit
    else
        echo -e "${YELLOW}gh-pages branch does not exist. Creating...${NC}"
        git checkout -b gh-pages
        git merge master --no-edit
    fi

    # Push to gh-pages branch
    git push origin gh-pages
    if [ $? -ne 0 ]; then
        echo -e "${RED}Failed to push to gh-pages.${NC}"
        exit 1
    fi
    echo -e "${GREEN}Changes pushed to gh-pages successfully!${NC}"
    # Switch back to master branch
    git checkout master
}


#  Run deployment function
deploy_to_github
# Check if the deployment was successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Deployment to GitHub was successful!${NC}"
else
    echo -e "${RED}Deployment to GitHub failed!${NC}"
fi