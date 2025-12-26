# config.ps1

$Config = @{
    Username  = "NetworkEngCode"
    BirthYear = 1988

    AsciiArtFile = ".\ascii-art.txt"

    OutputFiles = @{
        Dark  = "dark_mode.svg"
        Light = "light_mode.svg"
    }

    Layout = @{
        Width       = 900
        Height      = 560
        FontSize    = 14
        LineHeight  = 18

        # ASCII block position (left side)
        AsciiX      = 20
        AsciiY      = 75

        # Right-side content position
        ContentX    = 360
        ContentY    = 95

        TargetWidth = 56
    }

    Profile = [ordered]@{
        OS                      = "Windows"
        Host                    = "N/A"
        Kernel                  = "Network Automation Engineer"
        IDE                     = "VS Code"
        "Languages.Programming" = "Python"
        Hobbies                 = "Networking, Automation"
    }

    Contact = [ordered]@{
        GitHub   = "NetworkEngCode"
        LinkedIn = "jerryrico"
    }

    Colors = @{
        Dark = @{
            Background = "#0d1117"
            Text       = "#c9d1d9"
            Key        = "#58a6ff"
            Value      = "#c9d1d9"
            Dots       = "#8b949e"
            AddColor   = "#3fb950"
            DelColor   = "#f85149"
        }
        Light = @{
            Background = "#ffffff"
            Text       = "#24292f"
            Key        = "#0969da"
            Value      = "#24292f"
            Dots       = "#57606a"
            AddColor   = "#1a7f37"
            DelColor   = "#cf222e"
        }
    }
}
# New-ProfileSvg.ps1
# Generates dark_mode.svg and light_mode.svg from config.ps1
# Run this script once to create your SVG templates, then use today.ps1 to update dynamic stats

$ErrorActionPreference = "Stop"

# Load configuration
if (Test-Path ".\config.ps1") {
    . .\config.ps1
}
else {
    throw "config.ps1 not found! Please create it from the template."
}

function Get-DotJustifiedLine {
    param(
        [string]$Key,
        [string]$Value,
        [int]$TargetWidth = 56
    )

    $keyLen = $Key.Length + 1  # +1 for colon
    $valueLen = $Value.Length
    $dotsNeeded = $TargetWidth - $keyLen - $valueLen - 2  # -2 for spaces around dots

    if ($dotsNeeded -lt 1) { $dotsNeeded = 1 }

    return "." * $dotsNeeded
}

function Get-AsciiArtLines {
    param([string]$FilePath)

    if (-not (Test-Path $FilePath)) {
        Write-Warning "ASCII art file not found: $FilePath"
        return @()
    }

    return Get-Content $FilePath
}

function New-SvgDocument {
    param(
        [hashtable]$Colors,
        [string]$Mode  # "Dark" or "Light"
    )

    $c = $Colors
    $layout = $Config.Layout
    $targetWidth = $layout.TargetWidth

    # Optional layout offsets (prevents overlaps)
    $asciiStartY   = if ($layout.ContainsKey("AsciiY"))   { [int]$layout.AsciiY }   else { 30 }
    $contentStartY = if ($layout.ContainsKey("ContentY")) { [int]$layout.ContentY } else { 30 }

    # Calculate age from birth year
    $years = (Get-Date).Year - $Config.BirthYear
    $yearPlural = if ($years -ne 1) { "s" } else { "" }
    $ageValue = "$years year$yearPlural"

    # Build SVG header and styles
    $svg = @"
<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" font-family="ConsolasFallback,Consolas,monospace" width="$($layout.Width)px" height="$($layout.Height)px" font-size="$($layout.FontSize)px">
  <style>
@font-face {
src: local('Consolas'), local('Consolas Bold');
font-family: 'ConsolasFallback';
font-display: swap;
-webkit-size-adjust: 109%;
size-adjust: 109%;
}
.key {fill: $($c.Key);}
.value {fill: $($c.Value);}
.addColor {fill: $($c.AddColor);}
.delColor {fill: $($c.DelColor);}
.cc {fill: $($c.Dots);}
text, tspan {white-space: pre;}
</style>
  <rect width="$($layout.Width)px" height="$($layout.Height)px" fill="$($c.Background)" rx="15" />
"@

    # Add ASCII art section
    $asciiLines = Get-AsciiArtLines -FilePath $Config.AsciiArtFile
    $svg += "`n  <text x=`"$($layout.AsciiX)`" y=`"$asciiStartY`" fill=`"$($c.Text)`" class=`"ascii`">"

    $y = $asciiStartY
    foreach ($line in $asciiLines) {
        $escapedLine = $line -replace '&', '&amp;' -replace '<', '&lt;' -replace '>', '&gt;'
        $svg += "`n    <tspan x=`"$($layout.AsciiX)`" y=`"$y`">$escapedLine</tspan>"
        $y += $layout.LineHeight
    }
    $svg += "`n  </text>"

    # Build content section
    $contentX = $layout.ContentX
    $svg += "`n  <text x=`"$contentX`" y=`"$contentStartY`" fill=`"$($c.Text)`">"

    # Username header
    $emDash = [char]0x2014
    $svg += "`n    <tspan x=`"$contentX`" y=`"$contentStartY`">$($Config.Username)</tspan> -"
    $svg += ($emDash.ToString() * 43)
    $svg += "-$emDash-"

    # Profile section
    $y = $contentStartY + 20
    foreach ($key in $Config.Profile.Keys) {
        if ($key -eq "Uptime" -or $null -eq $Config.Profile[$key]) {
            $dots = Get-DotJustifiedLine -Key "Uptime" -Value $ageValue -TargetWidth $targetWidth
            $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan>"
            $svg += "<tspan class=`"key`">Uptime</tspan>:"
            $svg += "<tspan class=`"cc`" id=`"age_data_dots`"> $dots </tspan>"
            $svg += "<tspan class=`"value`" id=`"age_data`">$ageValue</tspan>"
        }
        elseif ($key -eq "Languages.Programming") {
            $value = $Config.Profile[$key]
            $dots = Get-DotJustifiedLine -Key $key -Value $value -TargetWidth $targetWidth
            $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan>"
            $svg += "<tspan class=`"key`">Languages</tspan>.<tspan class=`"key`">Programming</tspan>:"
            $svg += "<tspan class=`"cc`"> $dots </tspan>"
            $svg += "<tspan class=`"value`">$value</tspan>"
        }
        else {
            $value = $Config.Profile[$key]
            $dots = Get-DotJustifiedLine -Key $key -Value $value -TargetWidth $targetWidth
            $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan>"
            $svg += "<tspan class=`"key`">$key</tspan>:"
            $svg += "<tspan class=`"cc`"> $dots </tspan>"
            $svg += "<tspan class=`"value`">$value</tspan>"
        }
        $y += $layout.LineHeight
    }

    # Contact header
    $y += $layout.LineHeight
    $svg += "<tspan x=`"$contentX`" y=`"$y`">- Contact</tspan> -"
    $svg += ($emDash.ToString() * 46)
    $svg += "-$emDash-"
    $y += $layout.LineHeight

    foreach ($key in $Config.Contact.Keys) {
        $value = $Config.Contact[$key]
        $dots = Get-DotJustifiedLine -Key $key -Value $value -TargetWidth $targetWidth
        $svg += "`n<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan>"
        $svg += "<tspan class=`"key`">$key</tspan>:"
        $svg += "<tspan class=`"cc`"> $dots </tspan>"
        $svg += "<tspan class=`"value`">$value</tspan>"
        $y += $layout.LineHeight
    }

    # GitHub Stats header
    $y += $layout.LineHeight
    $svg += "<tspan x=`"$contentX`" y=`"$y`">- GitHub Stats</tspan> -"
    $svg += ($emDash.ToString() * 41)
    $svg += "-$emDash-"
    $y += $layout.LineHeight

    # Stats lines (placeholders updated by today.ps1)
    $repoDots = Get-DotJustifiedLine -Key "Repos" -Value "0" -TargetWidth $targetWidth
    $svg += "`n<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan><tspan class=`"key`">Repos</tspan>:<tspan class=`"cc`" id=`"repo_data_dots`"> $repoDots </tspan><tspan class=`"value`" id=`"repo_data`">0</tspan>"
    $y += $layout.LineHeight

    $contribDots = Get-DotJustifiedLine -Key "Contributed" -Value "0" -TargetWidth $targetWidth
    $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan><tspan class=`"key`">Contributed</tspan>:<tspan class=`"cc`" id=`"contrib_data_dots`"> $contribDots </tspan><tspan class=`"value`" id=`"contrib_data`">0</tspan>"
    $y += $layout.LineHeight

    $starDots = Get-DotJustifiedLine -Key "Stars" -Value "0" -TargetWidth $targetWidth
    $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan><tspan class=`"key`">Stars</tspan>:<tspan class=`"cc`" id=`"star_data_dots`"> $starDots </tspan><tspan class=`"value`" id=`"star_data`">0</tspan>"
    $y += $layout.LineHeight

    $commitDots = Get-DotJustifiedLine -Key "Commits" -Value "0" -TargetWidth $targetWidth
    $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan><tspan class=`"key`">Commits</tspan>:<tspan class=`"cc`" id=`"commit_data_dots`"> $commitDots </tspan><tspan class=`"value`" id=`"commit_data`">0</tspan>"
    $y += $layout.LineHeight

    $followerDots = Get-DotJustifiedLine -Key "Followers" -Value "0" -TargetWidth $targetWidth
    $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan><tspan class=`"key`">Followers</tspan>:<tspan class=`"cc`" id=`"follower_data_dots`"> $followerDots </tspan><tspan class=`"value`" id=`"follower_data`">0</tspan>"
    $y += $layout.LineHeight

    $locDots = Get-DotJustifiedLine -Key "Lines of Code" -Value "0" -TargetWidth $targetWidth
    $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan><tspan class=`"key`">Lines of Code</tspan>:<tspan class=`"cc`" id=`"loc_data_dots`"> $locDots </tspan><tspan class=`"value`" id=`"loc_data`">0</tspan>"
    $y += $layout.LineHeight

    $addDelValue = "0++, 0--"
    $addDelDots = Get-DotJustifiedLine -Key "(+/-)" -Value $addDelValue -TargetWidth $targetWidth
    $svg += "<tspan x=`"$contentX`" y=`"$y`" class=`"cc`">. </tspan><tspan class=`"key`">(+/-)</tspan>:<tspan class=`"cc`" id=`"loc_add_del_dots`"> $addDelDots </tspan>"
    $svg += "<tspan class=`"addColor`" id=`"loc_add`">0</tspan><tspan class=`"addColor`">++</tspan>, "
    $svg += "<tspan class=`"delColor`" id=`"loc_del`">0</tspan><tspan class=`"delColor`">--</tspan>"

    # Close text element
    $svg += "`n</text>"

    # Color palette at bottom
    if ($Mode -eq "Dark") {
        $paletteColors = @("#555753", "#ef2929", "#8ae234", "#fce94f", "#729fcf", "#ad7fa8", "#34e2e2", "#eeeeec")
    }
    else {
        $paletteColors = @("#2e3436", "#cc0000", "#4e9a06", "#c4a000", "#3465a4", "#75507b", "#06989a", "#555753")
    }

    $paletteY = $y + ($layout.LineHeight * 2.5)
    $paletteX = $contentX
    $rectWidth = 24
    $rectHeight = 16

    for ($i = 0; $i -lt $paletteColors.Length; $i++) {
        $x = $paletteX + ($i * $rectWidth)
        $svg += "`n  <rect x=`"$x`" y=`"$paletteY`" width=`"$rectWidth`" height=`"$rectHeight`" fill=`"$($paletteColors[$i])`" rx=`"2`" />"
    }

    # Close SVG
    $svg += "`n</svg>`n"
    return $svg
}

Write-Host "Generating SVG files from config..."

# Dark mode
$darkSvg = New-SvgDocument -Colors $Config.Colors.Dark -Mode "Dark"
$darkSvg | Set-Content -Path $Config.OutputFiles.Dark -Encoding UTF8
Write-Host "  Created: $($Config.OutputFiles.Dark)"

# Light mode
$lightSvg = New-SvgDocument -Colors $Config.Colors.Light -Mode "Light"
$lightSvg | Set-Content -Path $Config.OutputFiles.Light -Encoding UTF8
Write-Host "  Created: $($Config.OutputFiles.Light)"

Write-Host "`nDone! Run today.ps1 to update GitHub statistics."
