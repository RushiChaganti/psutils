Set-StrictMode -Off;

$usage = @"
usage:
cat [-A] [-b] [-E] [-n] [-s] [-T] [-v] file ...
"@

$flags  = 'bEnsT'.ToCharArray()             # defines options without a parameter
$pflags = 'A'.ToCharArray()                 # defines options with a parameter
$opts   = New-Object Collections.Hashtable  # stores parsed options (case-sensitive keys)
$files  = @()                               # stored parsed files

function dbg($msg) { Write-Host $msg -ForegroundColor DarkYellow }  # for debugging
function expand($path) {
    $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($path)
}

# parse flags
for ($i = 0; $i -lt $args.Length; $i++) {
    $arg = $args[$i]
    if ($arg.StartsWith('-')) {
        $flag = $arg[1]

        if (($pflags -ccontains $flag) -and ($arg.Length -eq 2)) {
            # flag with a parameter
            if ($i -eq $args.Length - 1) {
                "cat: $flag requires a parameter"; $usage; exit 1
            }
            $opts[[string]$arg[1]] = $args[++$i]
        } elseif ($flags -ccontains $flag) {
            # flag(s) with no parameters (may be grouped together e.g. -bEnsT)
            $opts[[string]$flag] = $true
            for ($j = 2; $j -lt $arg.Length; $j++) {
                $flag = $arg[$j]
                if ($flags -ccontains $flag) { $opts[[string]$flag] = $true }
                else {
                    "cat: illegal option -- $flag"; $usage; exit 1
                }
            }
        } else {
            "cat: illegal option $($arg[1..($arg.Length - 1)])"; $usage; exit 1
        }
    } else {
        $files += $args[$i..($args.Length - 1)]; break # everything else is a file
    }
}

if (-not $files) { $usage; exit 1 }

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
