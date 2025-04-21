#!/usr/bin/env bash
# This script is used to deploy the application to a remote server on GitHub.
# It commits changes, pushes them to the master branch, merges them into the gh-pages branch, and pushes the gh-pages branch.

set -e  # (Stops execution if any command fails)
set -u  # (Treats unset variables as errors)

# Check if the commit message is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <commit_message>"
    exit 1
fi

commit_message="$1"

# Ensure the current branch is master
current_branch=$(git branch --show-current)
if [ "$current_branch" != "master" ]; then
    echo "Error: You must be on the 'master' branch to deploy."
    exit 1
fi

# Stage all changes
git add .

# Try to commit changes (if any)
git commit -m "$commit_message" || echo "No changes to commit."

# Push to master
git push origin master

# Switch to gh-pages
git checkout gh-pages

# Merge latest master into gh-pages
git merge master --no-edit

# Push gh-pages to GitHub
git push origin gh-pages

# Switch back to master
git checkout master

echo "✅ Deployment completed successfully."
