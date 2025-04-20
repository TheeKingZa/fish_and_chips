#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No color

# Make sure you're on master and it's up to date
git checkout master
git pull origin master

# Delete the local gh-pages if it exists
if git rev-parse --verify gh-pages >/dev/null 2>&1; then
    echo -e "${GREEN}✅ Deleting existing 'gh-pages' branch...${NC}"
    git branch -D gh-pages
fi

# Create a fresh copy of master called gh-pages
git checkout -b gh-pages

# Optional: Remove things you don't want on the live site (e.g., README, scripts, dev configs)
# rm deploy.sh README.md

# Ask for a commit message
echo -e "${GREEN}Enter a commit message:${NC}"
read -r commit_message

# Use default if empty
if [ -z "$commit_message" ]; then
    commit_message="Deploying fresh copy of master to gh-pages"
fi

# Add all changes and commit
git add .
git commit -m "$commit_message"

# Push to gh-pages (force to overwrite)
git push --force origin gh-pages

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Successfully deployed 'gh-pages' from 'master'.${NC}"
else
    echo -e "${RED}❌ Failed to push to 'gh-pages'.${NC}"
fi

# Switch back to master
git checkout master
