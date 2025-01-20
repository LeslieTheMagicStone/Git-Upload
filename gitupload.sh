dir_path=""
visibility="private"

# Parse arguments
for arg in "$@"; do
  case $arg in
    --public)
      visibility="public"
      ;;
    --private)
      visibility="private"
      ;;
    *)
      dir_path=$arg
      ;;
  esac
done

# Ensure dir_path is provided
if [ -z "$dir_path" ]; then
  echo "Directory path is required"
  exit 1
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
if ! gh repo view "$(basename "$dir_path")" &> /dev/null; then
  # Create GitHub repository if it doesn't exist
  gh repo create "$(basename "$dir_path")" --"$visibility" --source=. --remote=origin
else
  # Set the remote origin if the repository already exists
  git remote add origin "https://github.com/$github_username/$(basename "$dir_path").git"
fi

# Ensure the remote origin is set correctly
if ! git remote get-url origin &> /dev/null; then
  git remote add origin "https://github.com/$github_username/$(basename "$dir_path").git"
fi

# Add README.md if it doesn't exist
if [ ! -f "README.md" ]; then
  echo "# $(basename "$dir_path")" > README.md
fi

# Add .gitignore if it doesn't exist
if [ ! -f ".gitignore" ]; then
  if [ -f "$HOME/.gitupload/gitignore-template" ]; then
    cp "$HOME/.gitupload/gitignore-template" .gitignore
  fi
fi

# Add all changes and commit
git add .
git commit -m "init by Git-Upload"

# Push to GitHub remote
git push -u origin master
