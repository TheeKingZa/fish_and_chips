#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

# Check if gh-pages branch exists
if git show-ref --verify --quiet refs/heads/gh-pages; then
    echo -e "${GREEN}✅ 'gh-pages' branch already exists.${NC}"
else
    echo -e "${RED}❌ 'gh-pages' branch does not exist. Creating...${NC}"
    git checkout -b gh-pages
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 'gh-pages' branch created successfully.${NC}"
    else
        echo -e "${RED}❌ Failed to create 'gh-pages' branch.${NC}"
        exit 1
    fi
fi

# Ask for a commit message
echo -e "${GREEN}Enter a commit message:${NC}"
read -r commit_message

# Default commit message if none is provided
if [ -z "$commit_message" ]; then
    commit_message="Deploying to gh-pages"
fi

# Add and commit changes
git add .
git commit -m "$commit_message"

# Push to gh-pages
git push origin gh-pages

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Successfully pushed to 'gh-pages'.${NC}"
else
    echo -e "${RED}❌ Failed to push to 'gh-pages'.${NC}"
fi
