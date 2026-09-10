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
        elseif ($eventType -eq 2) { $fileName = "Alarm_$eventNum.gml" }
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

# Obj_ProyectilPlatano
Create-GMObject -name "Obj_ProyectilPlatano" -parentObj "" -events @(
    @{ type = 0; num = 0; code = "target = noone;`ndanio = 2;`nvelocidad_proyectil = 6;`nperfora_piedra = false;" },
    @{ type = 3; num = 0; code = "if (instance_exists(target)) {`n  move_towards_point(target.x, target.y, velocidad_proyectil);`n  if (point_distance(x, y, target.x, target.y) <= velocidad_proyectil) {`n    var d = danio;`n    if (target.resistente && !perfora_piedra) d = 1;`n    target.hp -= d;`n    target.path_speed -= 0.5;`n    target.path_speed = max(target.path_speed, 0.5);`n    target.alarm[1] = 90;`n    instance_destroy();`n  }`n} else { instance_destroy(); }" },
    @{ type = 8; num = 0; code = "if (sprite_index != -1) draw_self(); else { draw_set_color(c_yellow); draw_circle(x,y,4,false); draw_set_color(c_white); }" }
)

# Obj_TorreTripleT
Create-GMObject -name "Obj_TorreTripleT" -parentObj "Obj_TowerParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nrango = 60;`ndanio = 10;`ncooldown = 40;" }
)

# Obj_TorreLiriliralila
Create-GMObject -name "Obj_TorreLiriliralila" -parentObj "Obj_TowerParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nrango = 80;`ndanio = 5;`ncooldown = 50;" },
    @{ type = 3; num = 0; code = "if (cd_actual > 0) cd_actual--;`nelse {`n  var pego = false;`n  with (Obj_EnemyParent) {`n    if (camuflado && !other.puede_ver_camuflados) continue;`n    if (point_distance(x, y, other.x, other.y) <= other.rango) {`n      var d = other.danio;`n      if (resistente && !other.perfora_piedra) d = 1;`n      hp -= d;`n      pego = true;`n    }`n  }`n  if (pego) cd_actual = cooldown;`n}" }
)

# Obj_TorreChimpancini
Create-GMObject -name "Obj_TorreChimpancini" -parentObj "Obj_TowerParent" -events @(
    @{ type = 0; num = 0; code = "event_inherited();`nrango = 150;`ndanio = 3;`ncooldown = 45;" },
    @{ type = 3; num = 0; code = "if (cd_actual > 0) cd_actual--;`nelse {`n  var tgt = noone;`n  var min_dist = rango + 1;`n  with (Obj_EnemyParent) {`n    if (camuflado && !other.puede_ver_camuflados) continue;`n    var dist = point_distance(x, y, other.x, other.y);`n    if (dist <= other.rango && dist < min_dist) {`n      tgt = id;`n      min_dist = dist;`n    }`n  }`n  if (tgt != noone) {`n    var proj = instance_create_layer(x, y, `"Instances`", Obj_ProyectilPlatano);`n    proj.target = tgt;`n    proj.danio = danio;`n    proj.perfora_piedra = perfora_piedra;`n    cd_actual = cooldown;`n  }`n}" }
)

Write-Host "Done new objects!"
