#!/bin/bash

# Colors
GREEN='\033[0;32m' # Success
RED='\033[0;31m'   # Error
NC='\033[0m'       # Reset

# Variables
BRANCH="gh-pages"
DEFAULT_BRANCH="master" # change to 'main' if that's your default

# Functions
success() {
  echo -e "${GREEN}$1${NC}"
}

error() {
  echo -e "${RED}$1${NC}"
}

# Check if in a Git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  error "❌ Not a Git repository!"
  exit 1
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
  error "❌ Uncommitted changes found. Please commit or stash them first."
  exit 1
fi

# Check if gh-pages exists
if git show-ref --quiet refs/heads/$BRANCH; then
  success "✅ '$BRANCH' branch exists."
else
  success "📦 Creating '$BRANCH' branch..."
  git checkout --orphan $BRANCH || { error "❌ Failed to create branch."; exit 1; }
  git rm -rf . > /dev/null 2>&1
  touch .placeholder
  git add .placeholder
  git commit -m "Initial $BRANCH commit"
  git push origin $BRANCH
  success "✅ '$BRANCH' branch created and pushed."
fi

# Switch to gh-pages
git checkout $BRANCH || { error "❌ Could not switch to $BRANCH."; exit 1; }

# Copy main files (update paths as needed)
cp -r index.html style.css script.js menu.json . 2>/dev/null

git add .

# Prompt for commit message
read -p "📝 Enter a commit message: " commit_msg
if [ -z "$commit_msg" ]; then
  error "❌ Commit message is required!"
  git checkout $DEFAULT_BRANCH
  exit 1
fi

git commit -m "$commit_msg" || success "⚠️ Nothing to commit (already up to date)."
git push origin $BRANCH || { error "❌ Push failed."; git checkout $DEFAULT_BRANCH; exit 1; }

success "✅ Deployment to '$BRANCH' completed."

# Switch back
git checkout $DEFAULT_BRANCH || { error "❌ Failed to switch to $DEFAULT_BRANCH."; exit 1; }
success "🔁 Switched back to '$DEFAULT_BRANCH' branch."
