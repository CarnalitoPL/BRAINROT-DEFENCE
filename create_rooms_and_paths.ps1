$ErrorActionPreference = "Stop"

$projectDir = "c:\Users\prado\GameMakerProjects\BRAINROT DEFENCE 1"
$yypPath = Join-Path $projectDir "BRAINROT DEFENCE 1.yyp"

function Add-ResourceToYyp($name, $path) {
    $yypContent = Get-Content -Raw $yypPath
    if ($yypContent -match "`"name`":`"$name`"") {
        return # Already exists
    }
    
    $resourceJson = "    {`"id`":{`"name`":`"$name`",`"path`":`"$path`",},},`n"
    $yypContent = $yypContent -replace "`"resources`":\[", ("`"resources`":[`n" + $resourceJson)
    Set-Content -Path $yypPath -Value $yypContent
}

function Create-GMPath($name, $pointsStr) {
    $pathDir = Join-Path $projectDir "paths\$name"
    if (!(Test-Path $pathDir)) { New-Item -ItemType Directory -Path $pathDir | Out-Null }
    
    $yyPath = Join-Path $pathDir "$name.yy"
    
    $yyContent = @"
{
  "`$GMPath":"",
  "%Name":"$name",
  "closed":false,
  "kind":0,
  "name":"$name",
  "parent":{
    "name":"Phats",
    "path":"folders/Phats.yy",
  },
  "points":[
$pointsStr
  ],
  "precision":4,
  "resourceType":"GMPath",
  "resourceVersion":"2.0",
}
"@
    Set-Content -Path $yyPath -Value $yyContent
    Add-ResourceToYyp -name $name -path "paths/$name/$name.yy"
}

function Create-GMRoom($name) {
    $roomDir = Join-Path $projectDir "rooms\$name"
    if (!(Test-Path $roomDir)) { New-Item -ItemType Directory -Path $roomDir | Out-Null }
    
    $yyPath = Join-Path $roomDir "$name.yy"
    $room1Path = Join-Path $projectDir "rooms\Room1\Room1.yy"
    
    $roomContent = Get-Content -Raw $room1Path
    $roomContent = $roomContent -replace "`"%Name`":`"Room1`"", "`"%Name`":`"$name`""
    $roomContent = $roomContent -replace "`"name`":`"Room1`"", "`"name`":`"$name`""
    $roomContent = $roomContent -replace "`"path`":`"rooms/Room1/Room1.yy`"", "`"path`":`"rooms/$name/$name.yy`""
    
    Set-Content -Path $yyPath -Value $roomContent
    Add-ResourceToYyp -name $name -path "rooms/$name/$name.yy"
}

$pts_ciudad = @"
    {"speed":100.0,"x":0.0,"y":128.0,},
    {"speed":100.0,"x":256.0,"y":128.0,},
    {"speed":100.0,"x":256.0,"y":384.0,},
    {"speed":100.0,"x":1024.0,"y":384.0,},
    {"speed":100.0,"x":1024.0,"y":128.0,},
    {"speed":100.0,"x":1366.0,"y":128.0,}
"@

$pts_bosque = @"
    {"speed":100.0,"x":0.0,"y":600.0,},
    {"speed":100.0,"x":384.0,"y":600.0,},
    {"speed":100.0,"x":384.0,"y":200.0,},
    {"speed":100.0,"x":768.0,"y":200.0,},
    {"speed":100.0,"x":768.0,"y":600.0,},
    {"speed":100.0,"x":1366.0,"y":600.0,}
"@

$pts_mar = @"
    {"speed":100.0,"x":0.0,"y":300.0,},
    {"speed":100.0,"x":500.0,"y":300.0,},
    {"speed":100.0,"x":500.0,"y":500.0,},
    {"speed":100.0,"x":800.0,"y":500.0,},
    {"speed":100.0,"x":800.0,"y":300.0,},
    {"speed":100.0,"x":1366.0,"y":300.0,}
"@

Create-GMPath "Path_Ciudad" $pts_ciudad
Create-GMPath "Path_Bosque" $pts_bosque
Create-GMPath "Path_Mar" $pts_mar

Create-GMRoom "Rm_Ciudad"
Create-GMRoom "Rm_Bosque"
Create-GMRoom "Rm_Mar"

Write-Host "Done"
