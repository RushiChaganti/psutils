Set-StrictMode -Off

# Check for no arguments
if ($args.Length -eq 0) {
    Write-Host "usage: cat [-A] [-b] [-E] [-h] [-help] [-n] [-s] [-T] [-v] file ..."
    exit 1
}

$flags  = 'bEnsThv'.ToCharArray()           # defines options without a parameter
$pflags = 'A'.ToCharArray()                 # defines options with a parameter
$opts   = @{}                               # stores parsed options (case-sensitive keys)
$files  = @()                               # stores parsed files

# parse flags
for ($i = 0; $i -lt $args.Length; $i++) {
    $arg = $args[$i]
    if ($arg.StartsWith('-')) {
        $flag = $arg.Substring(1)

        if ($pflags -contains $flag[0]) {
            # flag with a parameter
            if ($i -eq $args.Length - 1) {
                Write-Host "cat: $flag requires a parameter"
                exit 1
            }
            $opts[[string]$flag[0]] = $args[++$i]
        } elseif ($flags -contains $flag[0]) {
            # flag(s) with no parameters (may be grouped together e.g. -bEnsT)
            foreach ($f in $flag.ToCharArray()) {
                if ($flags -contains $f) { $opts[[string]$f] = $true }
                else {
                    Write-Host "cat: illegal option -- $f"
                    exit 1
                }
            }
        } else {
            Write-Host "cat: illegal option $flag"
            exit 1
        }
    } else {
        $files += $args[$i..($args.Length - 1)]
        break # everything else is a file
    }
}

if (-not $files) { 
    Write-Host "usage: cat [-A] [-b] [-E] [-h] [-help] [-n] [-s] [-T] [-v] file ..."
    exit 1 
}

$lineNumber = 1
$previousLineEmpty = $false

function ShowSpecialChars($line) {
    if ($opts.T) {
        $line = $line -replace "`t", "^I"
    }
    if ($opts.v) {
        $line = $line -replace "[^`x20-`x7E]", {
            $c = $_.Value
            $charCode = [int][char]$c
            if ($charCode -lt 32) {
                return "^" + [char]($charCode + 64)
            } elseif ($charCode -eq 127) {
                return "^?"
            } elseif ($charCode -gt 127) {
                return "M-" + [char]($charCode - 128)
            }
        }
    }
    return $line
}

foreach ($file in $files) {
    if (-Not (Test-Path $file)) {
        Write-Error "Cannot open $file for reading"
        continue
    }

    Get-Content $file | ForEach-Object {
        $line = $_

        if ($opts.s) {
            if ($line -eq '') {
                if ($previousLineEmpty) {
                    return
                }
                $previousLineEmpty = $true
            } else {
                $previousLineEmpty = $false
            }
        }

        if ($opts.b) {
            if ($line -ne '') {
                Write-Host ("{0,6}  " -f $lineNumber) -NoNewline
                $lineNumber++
            }
        } elseif ($opts.n) {
            Write-Host ("{0,6}  " -f $lineNumber) -NoNewline
            $lineNumber++
        }

        if ($opts.A -or $opts.v -or $opts.T) {
            $line = ShowSpecialChars $line
        }

        if ($opts.A -or $opts.E) {
            Write-Host "$line`$"
        } else {
            Write-Host $line
        }
    }
}
