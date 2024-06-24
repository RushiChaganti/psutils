Set-StrictMode -Off

# Usage information
$usage = @"
usage:
cat [-A] [-b] [-E] [-h] [-help] [-n] [-s] [-T] [-v] file ...

Options:
  -A      Show all characters including non-printing characters and line endings
  -b      Number non-empty output lines, overrides -n
  -E      Display $ at end of each line
  -h, -help  Display this help and exit
  -n      Number all output lines
  -s      Squeeze multiple adjacent empty lines, causing the output to be single spaced
  -T      Display TAB characters as ^I
  -v      Use ^ and M- notation, except for LFD and TAB

Description:
  The cat command concatenates and displays files. It is a PowerShell equivalent
  of the Unix 'cat' command. It supports various options to display non-printing
  characters, number lines, squeeze blank lines, and more.
"@

Write-Host $usage
