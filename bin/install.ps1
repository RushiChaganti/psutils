param (
    [string]$targetPath
)

Write-Host "Starting installation of 'cat'..."

# Copy the scripts to the target path
Copy-Item -Path "bin\cat.ps1" -Destination "$targetPath\cat.ps1"
Copy-Item -Path "bin\cat-help.ps1" -Destination "$targetPath\cat-help.ps1"

# Create shims
$scoopDir = (Get-Item "$targetPath").Parent.FullName
$shimsDir = "$scoopDir\shims"

Write-Host "Creating shims for 'cat' and 'cat-help'..."
New-Item -ItemType SymbolicLink -Path "$shimsDir\cat.ps1" -Target "$targetPath\cat.ps1" -Force
New-Item -ItemType SymbolicLink -Path "$shimsDir\cat-help.ps1" -Target "$targetPath\cat-help.ps1" -Force

Write-Host "'cat' was installed successfully!"

Write-Host "`nFor help, use 'cat-help'."
Write-Host "To use the 'cat' command with options, use 'cat -<option> <file>'."
Write-Host "Check out 'cat-help' for more details on available options."
