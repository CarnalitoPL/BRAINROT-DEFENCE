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

function Create-GMObject($name, $parentObj, $events) {
    $objDir = Join-Path $projectDir "objects\$name"
    if (!(Test-Path $objDir)) { New-Item -ItemType Directory -Path $objDir | Out-Null }
    
    $eventListStr = ""
    foreach ($ev in $events) {
        $eventType = $ev.type
        $eventNum = $ev.num
        $code = $ev.code
        
        $eventListStr += "    {`"`$GMEvent`":`"`",`"%Name`":`"`",`"collisionObjectId`":null,`"eventNum`":$eventNum,`"eventType`":$eventType,`"isDnD`":false,`"name`":`"`",`"resourceType`":`"GMEvent`",`"resourceVersion`":`"2.0`",},`n"
        
        $fileName = ""
        if ($eventType -eq 0) { $fileName = "Create_$eventNum.gml" }
        elseif ($eventType -eq 1) { $fileName = "Destroy_$eventNum.gml" }
        elseif ($eventType -eq 3) { $fileName = "Step_$eventNum.gml" }
        elseif ($eventType -eq 6) { $fileName = "Mouse_$eventNum.gml" }
        elseif ($eventType -eq 8) { $fileName = "Draw_$eventNum.gml" }
        
        if ($fileName -ne "") {
            Set-Content -Path (Join-Path $objDir $fileName) -Value $code
        }
    }
    
    $parentIdStr = "null"
    if ($parentObj -ne $null -and $parentObj -ne "") {
        $parentIdStr = "{`"name`":`"$parentObj`",`"path`":`"objects/$parentObj/$parentObj.yy`",}"
    }

    $yyContent = @"
{
  "`$GMObject":"",
  "%Name":"$name",
  "eventList":[
$eventListStr  ],
  "managed":true,
  "name":"$name",
  "overriddenProperties":[],
  "parent":{
    "name":"Objetos",
    "path":"folders/Objetos.yy",
  },
  "parentObjectId":$parentIdStr,
  "persistent":false,
  "physicsAngularDamping":0.1,
  "physicsDensity":0.5,
  "physicsFriction":0.2,
  "physicsGroup":1,
  "physicsKinematic":false,
  "physicsLinearDamping":0.1,
  "physicsObject":false,
  "physicsRestitution":0.1,
  "physicsSensor":false,
  "physicsShape":1,
  "physicsShapePoints":[],
  "physicsStartAwake":true,
  "properties":[],
  "resourceType":"GMObject",
  "resourceVersion":"2.0",
  "solid":false,
  "spriteId":null,
  "spriteMaskId":null,
  "visible":true,
}
"@
    Set-Content -Path (Join-Path $objDir "$name.yy") -Value $yyContent
    Add-ResourceToYyp -name $name -path "objects/$name/$name.yy"
}

# Obj_GameController
Create-GMObject -name "Obj_GameController" -parentObj "" -events @(
    @{ type = 0; num = 0; code = "global.vida = 100;`nglobal.dinero = 50;`nglobal.oleada = 1;`nalarm[0] = 60;" },
    @{ type = 2; num = 0; code = "instance_create_layer(0, 0, `"Instances`", Obj_EnemigoPez);`nalarm[0] = 120;" },
    @{ type = 8; num = 64; code = "draw_text(10, 10, `"Vida: `" + string(global.vida));`ndraw_text(10, 30, `"Dinero: $`" + string(global.dinero));`ndraw_text(10, 50, `"Oleada: `" + string(global.oleada));" }
)

# Obj_EnemyParent
Create-GMObject -name "Obj_EnemyParent" -parentObj "" -events @(
    @{ type = 0; num = 0; code = "hp = 10;`nspeed_base = 2;`nvalor = 5;`ncamuflado = false;`nresistente = false;`npath_start(Path_Enemy, speed_base, path_action_stop, true);" },
    @{ type = 3; num = 0; code = "if (hp <= 0) {`n  global.dinero += valor;`n  instance_destroy();`n}`nif (path_position >= 0.99) {`n  global.vida -= 10;`n  instance_destroy();`n}" }
)

# Obj_EnemigoPez
Create-GMObject -name "Obj_EnemigoPez" -parentObj "Obj_EnemyParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nhp = 10;`nspeed_base = 2;" }
)

# Obj_EnemigoPezPiedra
Create-GMObject -name "Obj_EnemigoPezPiedra" -parentObj "Obj_EnemyParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nhp = 30;`nspeed_base = 1.5;`nresistente = true;" }
)

# Obj_EnemigoPulpo
Create-GMObject -name "Obj_EnemigoPulpo" -parentObj "Obj_EnemyParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nhp = 15;`nspeed_base = 1.8;`ncamuflado = true;" },
    @{ type = 8; num = 0; code = "if (!camuflado) {`n  draw_self();`n} else {`n  draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 0.3);`n}" }
)

# Obj_TowerParent
Create-GMObject -name "Obj_TowerParent" -parentObj "" -events @(
    @{ type = 0; num = 0; code = "rango = 100;`ndanio = 5;`ncooldown = 30;`ncd_actual = 0;`npuede_ver_camuflados = false;`nperfora_piedra = false;`nnivel = 1;" },
    @{ type = 3; num = 0; code = "if (cd_actual > 0) cd_actual--;`nelse {`n  var target = noone;`n  var min_dist = rango + 1;`n  with (Obj_EnemyParent) {`n    if (camuflado && !other.puede_ver_camuflados) continue;`n    var dist = point_distance(x, y, other.x, other.y);`n    if (dist <= other.rango && dist < min_dist) {`n      target = id;`n      min_dist = dist;`n    }`n  }`n  if (target != noone) {`n    var d = danio;`n    if (target.resistente && !perfora_piedra) d = 1;`n    target.hp -= d;`n    cd_actual = cooldown;`n  }`n}" },
    @{ type = 6; num = 4; code = "if (global.dinero >= 50) {`n  global.dinero -= 50;`n  nivel++;`n  danio += 2;`n}" }
)

# Obj_TorreBasica
Create-GMObject -name "Obj_TorreBasica" -parentObj "Obj_TowerParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nrango = 120;`ndanio = 5;`ncooldown = 30;" }
)

# Obj_TorreDinero
Create-GMObject -name "Obj_TorreDinero" -parentObj "Obj_TowerParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nrango = 0;`ndanio = 0;`ncooldown = 120;`ncd_actual = cooldown;" },
    @{ type = 3; num = 0; code = "if (cd_actual > 0) cd_actual--;`nelse {`n  global.dinero += 10 + (nivel * 5);`n  cd_actual = cooldown;`n}" }
)

# Create Path
function Create-GMPath($name) {
    $pathDir = Join-Path $projectDir "paths\$name"
    if (!(Test-Path $pathDir)) { New-Item -ItemType Directory -Path $pathDir | Out-Null }
    
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
    {"x":0.0,"y":384.0,},
    {"x":1366.0,"y":384.0,},
  ],
  "precision":4,
  "resourceType":"GMPath",
  "resourceVersion":"2.0",
}
"@
    Set-Content -Path (Join-Path $pathDir "$name.yy") -Value $yyContent
    Add-ResourceToYyp -name $name -path "paths/$name/$name.yy"
}

Create-GMPath -name "Path_Enemy"

Write-Host "Done!"
