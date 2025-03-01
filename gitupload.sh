#!/bin/bash

# Function to display usage
usage() {
  echo "Usage: $0 [-p] [-r] [-i] [-h] directory [repository]"
  echo "  -p             Set the repository visibility to public"
  echo "  -r             Include README template"
  echo "  -i             Include .gitignore template"
  echo "  -h             Display this help message"
  echo "  directory      Local directory to upload"
  echo "  repository     (Optional) Name of the GitHub repository"
  exit 0 
}

# Default values
visibility="private"
include_readme=false
include_gitignore=false

# Parse options
while getopts ":prih" opt; do
  case ${opt} in
    p )
      visibility="public"
      ;;
    r )
      include_readme=true
      ;;
    i )
      include_gitignore=true
      ;;
    h )
      usage
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument" 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Ensure dir_path is provided
dir_path=$1
if [ -z "$dir_path" ]; then
  echo "Directory path is required"
  usage
fi

# Set repository name
repo_name=$2
if [ -z "$repo_name" ]; then
  # Handle various path edge cases
  if [ "$dir_path" = "." ]; then
    repo_name=$(basename "$(pwd)")
  elif [[ "$dir_path" == ".." || "$dir_path" == "../"* || "$dir_path" == *"/.."* ]]; then
    # For paths with "..", resolve to absolute path first
    abs_path=$(cd "$dir_path" && pwd)
    repo_name=$(basename "$abs_path")
  else
    repo_name=$(basename "$dir_path")
  fi
fi

# Open directory at dir_path
cd "$dir_path" || { echo "Directory not found"; exit 1; }

# Check if it is already a git repo
if [ -d ".git" ]; then
  echo "Already a git repository"
  exit 1
fi

# Initialize git repository if not already a git repo
if [ ! -d ".git" ]; then
  git init
fi

# Get the GitHub username
github_username=$(gh auth status --show-token | awk '/Logged in to github.com account/ {print $7}')

# Check if remote repository exists using GitHub CLI
if ! gh repo view "$repo_name" &> /dev/null; then
  # Create GitHub repository if it doesn't exist
  gh repo create "$repo_name" --"$visibility" --source=. --remote=origin
else
  # Set the remote origin if the repository already exists
  git remote add origin "https://github.com/$github_username/$repo_name.git"
fi

# Ensure the remote origin is set correctly
if ! git remote get-url origin &> /dev/null; then
  git remote add origin "https://github.com/$github_username/$repo_name.git"
fi

# Add README.md if it doesn't exist and the option is set
if [ "$include_readme" = true ] && [ ! -f "README.md" ]; then
  echo "# $repo_name" > README.md
fi

# Add .gitignore if it doesn't exist and the option is set
if [ "$include_gitignore" = true ] && [ ! -f ".gitignore" ]; then
  if [ -f "$HOME/.gitupload/gitignore-template" ]; then
    cp "$HOME/.gitupload/gitignore-template" .gitignore
  fi
fi

# Add all changes and commit
git add .
git commit -m "init by Git-Upload"

# Push to GitHub remote
git push -u origin master
