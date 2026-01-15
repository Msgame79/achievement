Set-Location $PSScriptRoot

$a = Invoke-RestMethod "https://docs.google.com/spreadsheets/d/1Rq0ehUYOnGRNwRWagnGfawnW8IPpVpNESB3sOOL8CEY/export?format=csv&id=1Rq0ehUYOnGRNwRWagnGfawnW8IPpVpNESB3sOOL8CEY&gid=1558613575" | ConvertFrom-Csv

$Categories = $a.category | Sort-Object | Get-unique
foreach ($Category in $Categories) {
    $Category1 = [Regex]::Matches($Category, "0*(.+)").groups[1].value
    while (Test-Path $Category1) {
        Remove-Item $Category1 -Recurse -Force
    }
    New-Item -ItemType Directory $Category1 | Out-Null
    foreach ($ach in ($a | Where-Object {$_.category -eq $Category})) {
        $number = $ach.number
        $id = $ach.id
        $jatitle = $ach.ja_title
        $jadesc = $ach.ja_desc
        $entitle = $ach.en_title
        $endesc = $ach.en_desc
        $cntitle = $ach.cn_title
        $cndesc = $ach.cn_desc
        New-Item -ItemType Directory "$Category1\$number.$id" | Out-Null
        Copy-Item -Path "img\$id.jpg" -Destination "$Category1\$number.$id\achimage.jpg"
        [Regex]::Replace([Regex]::Replace([Regex]::Replace([Regex]::Replace([Regex]::Replace([Regex]::Replace([Regex]::Replace([Regex]::Replace((Get-Content template.mlt), "\{cn_desc\}", $cndesc), "\{cn_title\}", $cntitle), "\{en_desc\}", $endesc), "\{en_title\}", $entitle), "\{ja_desc\}", $jadesc), "\{ja_title\}", $jatitle), "\{ID\}", $id), "\{number\}", $number) | Out-File "$Category1\$number.$id\template.mlt"
    }
}