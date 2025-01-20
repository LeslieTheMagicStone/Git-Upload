# Git-Upload
Upload local directory to github with specified .gitignore

## Setup

### Install GitHub CLI
If you haven't installed the GitHub CLI, follow the instructions [here](https://github.com/cli/cli#installation).

### Installation
```bash
./install.sh
```
(Optional) To upload with specified .gitignore file, save your .gitignore template in:
`~/.gitupload/gitignore-template`

## Example Usage
```bash
gitupload --public ~/Documents/UnityProjects/GuichuStarFight
