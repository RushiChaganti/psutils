# psutils

A PowerShell equivalent of the Unix 'cat' command.

## Installation

### Prerequisites

- Windows PowerShell 5.1 or PowerShell Core 6.0+
- [Scoop](https://scoop.sh/): A command-line installer for Windows

### Install Scoop

If you haven't installed Scoop yet, you can install it by running the following command in PowerShell:

```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
```
### Install psutils

Once Scoop is installed, you can install psutils by running the following commands:
Clone the psutils repository:
```
git clone https://github.com/RushiChaganti/psutils.git
```
Navigate to the manifests directory:
```
cd psutils/manifests
```
Install psutils using Scoop:
```
scoop install cat.json
```
### Usage

After installation, you can use the cat command in PowerShell:
```
cat <file-path>
```
For help or more information, you can use:

```
cat-help
```
### Project Information

    Version: 0.2024.01
    Homepage: psutils on GitHub
    Description: A PowerShell equivalent of the Unix 'cat' command.
    License: MIT

### Development and Contribution

If you want to contribute to this project, please fork the repository and submit a pull request. For major changes, please open an issue first to discuss what you would like to change.
### License

This project is licensed under the MIT License - see the LICENSE file for details.
