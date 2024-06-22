Set-StrictMode -Off

$usage = "usage: cat [-A [-][[hh]mm]SS] [-benstuvAET] [FILE]..."

$flags  = 'benstuvAET'.tochararray()              # defines options without a parameter
$pflags = @()                              # defines options with a parameter
$opts   = new-object collections.hashtable # stores parsed options (case-sensitive keys)
$files  = @()                              # stored parsed files

function dbg($msg) { write-host $msg -f darkyellow }  # for debugging
function expand($path) {
    $executionContext.sessionState.path.getUnresolvedProviderPathFromPSPath($path)
}

# parse flags
for($i = 0; $i -lt $args.length; $i++) {
    $arg = $args[$i]
    if($arg.startswith('-')) {
        $flag = $arg

        if($flags -ccontains $flag) {
            # flag with no parameters
            $opts[[string]$flag] = $true
            for($j = 2; $j -lt $arg.length; $j++) {
                $flag = $arg[$j]
                if($flags -ccontains $flag) { $opts[[string]$flag] = $true }
                else {
                    "cat: illegal option -- $flag"; $usage; exit 1
                }
            }
        } else {
            "cat: illegal option $($arg[1..($arg.length - 1)])"; $usage; exit 1
        }
    } else {
        $files += $args[$i..($args.length - 1)]; break # everything else is a file
    }
}

# process files
if(!$files) { $usage; exit 1 }

foreach($file in $files) {
    if(!(test-path $file)) { "cat: $file: no such file or directory"; exit 1 }

    $content = Get-Content -Path $file

    if($opts.b) {
        $lineNumber = 1
        foreach ($line in $content) {
            Write-Host "$lineNumber`t$line"
            $lineNumber++
        }
    } elseif($opts.e) {
        foreach ($line in $content) {
            $newLine = ""
            foreach ($char in $line.ToCharArray()) {
                if ($char -eq 127) {
                    $newLine += "^?"
                } else {
                    $newLine += $char
                }
            }
            Write-Host $newLine
        }
    } elseif($opts.n) {
        $lineNumber = 1
        foreach ($line in $content) {
            Write-Host "$lineNumber`t$line"
            $lineNumber++
        }
    } elseif($opts.s) {
        $prevLineBlank = $false
        foreach ($line in $content) {
            if ($line -ne "") {
                Write-Host $line
                $prevLineBlank = $false
            } elseif (!$prevLineBlank) {
                Write-Host
                $prevLineBlank = $true
            }
        }
    } elseif($opts.t) {
        foreach ($line in $content) {
            $newLine = ""
            foreach ($char in $line.ToCharArray()) {
                if ($char -eq 9) {
                    $newLine += "^I"
                } else {
                    $newLine += $char
                }
            }
            Write-Host $newLine
        }
    } elseif($opts.u) {
        # ignored
    } elseif($opts.v) {
        foreach ($line in $content) {
            $newLine = ""
            foreach ($char in $line.ToCharArray()) {
                if ($char -ge 32 -and $char -lt 127) {
                    $newLine += $char
                } elseif ($char -eq 127) {
                    $newLine += "^?"
                } else {
                    $newLine += "^" + [char]($char + 64)
                }
            }
            Write-Host $newLine
        }
    } elseif($opts.A) {
        foreach ($line in $content) {
            Write-Host "$line$"
        }
    } else {
        Write-Host $content
    }
}

exit 0
