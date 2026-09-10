$projectDir = "c:\Users\prado\GameMakerProjects\BRAINROT DEFENCE 1"
$yypPath = Join-Path $projectDir "BRAINROT DEFENCE 1.yyp"

function Add-ResourceToYyp($name, $path) {
    $yypContent = Get-Content -Raw $yypPath
    if ($yypContent -match "`"name`":`"$name`"") { return }
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

function Create-GMRoom($name, $instName, $objName) {
    $roomDir = Join-Path $projectDir "rooms\$name"
    if (!(Test-Path $roomDir)) { New-Item -ItemType Directory -Path $roomDir | Out-Null }
    
    $yyContent = @"
{
  "`$GMRoom":"v1",
  "%Name":"$name",
  "creationCodeFile":"",
  "inheritCode":false,
  "inheritCreationOrder":false,
  "inheritLayers":false,
  "instanceCreationOrder":[],
  "isDnd":false,
  "layers":[
    {"`$GMRInstanceLayer":"","%Name":"Instances","depth":0,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"instances":[
      {"`$GMRInstance":"v4","%Name":"$instName","colour":4294967295,"frozen":false,"hasCreationCode":false,"ignore":false,"imageIndex":0,"imageSpeed":1.0,"inheritCode":false,"inheritedItemId":null,"inheritItemSettings":false,"isDnd":false,"name":"$instName","objectId":{"name":"$objName","path":"objects/$objName/$objName.yy",},"properties":[],"resourceType":"GMRInstance","resourceVersion":"2.0","rotation":0.0,"scaleX":1.0,"scaleY":1.0,"x":0.0,"y":0.0,}
    ],"layers":[],"name":"Instances","properties":[],"resourceType":"GMRInstanceLayer","resourceVersion":"2.0","userdefinedDepth":false,"visible":true,},
    {"`$GMRBackgroundLayer":"","%Name":"Background","animationFPS":15.0,"animationSpeedType":0,"colour":4282004530,"depth":100,"effectEnabled":true,"effectType":null,"gridX":32,"gridY":32,"hierarchyFrozen":false,"hspeed":0.0,"htiled":false,"inheritLayerDepth":false,"inheritLayerSettings":false,"inheritSubLayers":true,"inheritVisibility":true,"layers":[],"name":"Background","properties":[],"resourceType":"GMRBackgroundLayer","resourceVersion":"2.0","spriteId":null,"stretch":false,"userdefinedAnimFPS":false,"userdefinedDepth":false,"visible":true,"vspeed":0.0,"vtiled":false,"x":0,"y":0,}
  ],
  "name":"$name",
  "parent":{"name":"Rooms","path":"folders/Rooms.yy",},
  "parentRoom":null,
  "physicsSettings":{"inheritPhysicsSettings":false,"PhysicsWorld":false,"PhysicsWorldGravityX":0.0,"PhysicsWorldGravityY":10.0,"PhysicsWorldPixToMetres":0.1,},
  "resourceType":"GMRoom",
  "resourceVersion":"2.0",
  "roomSettings":{"Height":768,"inheritRoomSettings":false,"persistent":false,"Width":1366,},
  "sequenceId":null,
  "views":[
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,},
    {"hborder":32,"hport":768,"hspeed":-1,"hview":768,"inherit":false,"objectId":null,"vborder":32,"visible":false,"vspeed":-1,"wport":1366,"wview":1366,"xport":0,"xview":0,"yport":0,"yview":0,}
  ],
  "viewSettings":{"clearDisplayBuffer":true,"clearViewBackground":false,"enableViews":false,"inheritViewSettings":false,},
  "volume":1.0,
}
"@
    Set-Content -Path (Join-Path $roomDir "$name.yy") -Value $yyContent
    Add-ResourceToYyp -name $name -path "rooms/$name/$name.yy"
}

# Obj_RecursoDinero
Create-GMObject -name "Obj_RecursoDinero" -parentObj "" -events @(
    @{ type = 0; num = 0; code = "valor = 10;`ntiempo_vida = 300;" },
    @{ type = 3; num = 0; code = "if (global.estado_juego == `"pausado`" || global.estado_juego == `"game_over`" || global.estado_juego == `"victoria`") exit;`ntiempo_vida--;`nif (tiempo_vida <= 0) instance_destroy();`nif (mouse_check_button_pressed(mb_left)) {`n  if (point_distance(mouse_x, mouse_y, x, y) < 30) {`n    global.dinero += valor;`n    instance_destroy();`n  }`n}" },
    @{ type = 8; num = 0; code = "if (sprite_index != -1) draw_self();`nelse {`n  draw_set_color(c_lime);`n  draw_circle(x, y, 12, false);`n  draw_set_color(c_black);`n  draw_text(x-5, y-8, `"$`");`n  draw_set_color(c_white);`n}" }
)

# Obj_MenuController
Create-GMObject -name "Obj_MenuController" -parentObj "" -events @(
    @{ type = 8; num = 64; code = "draw_set_color(c_white);`ndraw_set_halign(fa_center);`ndraw_text_transformed(1366/2, 200, `"BRAINROT DEFENCE`", 3, 3, 0);`n`ndraw_set_color(c_green);`ndraw_rectangle(1366/2 - 100, 400, 1366/2 + 100, 480, false);`ndraw_set_color(c_black);`ndraw_text_transformed(1366/2, 425, `"JUGAR`", 2, 2, 0);`ndraw_set_halign(fa_left);`ndraw_set_color(c_white);" },
    @{ type = 3; num = 0; code = "if (mouse_check_button_pressed(mb_left)) {`n  var mx = device_mouse_x_to_gui(0);`n  var my = device_mouse_y_to_gui(0);`n  if (mx > 1366/2 - 100 && mx < 1366/2 + 100 && my > 400 && my < 480) {`n    room_goto(Room1);`n  }`n}" }
)

# Room MenuInit
Create-GMRoom -name "Rm_MenuInit" -instName "inst_MenuInitController" -objName "Obj_MenuController"

Write-Host "Part 1 done!"
