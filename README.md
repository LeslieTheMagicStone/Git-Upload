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
Upload `~/UnityProjects/GuichuStarFight` to github as a **p**ublic repository and add .git**i**gnore file and **r**eadme file.
```bash
gitupload -pir ~/UnityProjects/GuichuStarFight
```

Upload `./foo` to github as a (private) repository named `bar` (without adding .gitignore file and readme file).
```bash
gitupload ./foo bar
```

Display the help message.
```bash
gitupload -h
```
