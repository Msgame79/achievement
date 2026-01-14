Set-Location $PSScriptRoot

$a = Invoke-RestMethod "https://raw.githubusercontent.com/Msgame79/AchVideos/refs/heads/main/a.json"

$Levels = $a.psobject.properties.name
$Achievements = @()
foreach ($Level in $Levels) {
    $Achievements += @($a.$Level)
}
for ($i = 0; $i -lt $Levels.Length; $i++) {
    New-Item -ItemType Directory "$($Levels[$i])"
    foreach ($Achievement in $Achievements[$i]) {
        New-Item -ItemType Directory "$($Levels[$i])\${Achievement}"
        Copy-Item -Path ".\template.mlt" -Destination ".\$($Levels[$i])\${Achievement}"
    }
}
