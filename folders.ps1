Set-Location $PSScriptRoot

$a = Invoke-RestMethod "https://raw.githubusercontent.com/Msgame79/AchVideos/refs/heads/main/a.json"

$Levels = $a.psobject.properties.name
for ($i = 0; $i -lt $Levels.Length; $i++) {
    while (Test-Path "$($Levels[$i])") {
        Remove-Item "$($Levels[$i])" -Recurse -Force
    }
    New-Item -ItemType Directory "$($Levels[$i])" | Out-Null
    foreach ($Achievement in $a.($Levels[$i])) {
        New-Item -ItemType Directory "$($Levels[$i])\${Achievement}" | Out-Null
        Copy-Item -Path ".\template.mlt" -Destination ".\$($Levels[$i])\${Achievement}"
    }
}