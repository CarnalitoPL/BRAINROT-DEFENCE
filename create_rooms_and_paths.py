import json
import os

PROJECT_DIR = r"c:\Users\prado\GameMakerProjects\BRAINROT DEFENCE 1"
YYP_PATH = os.path.join(PROJECT_DIR, "BRAINROT DEFENCE 1.yyp")

def add_resource(name, type_str, path_in_project):
    with open(YYP_PATH, 'r', encoding='utf-8') as f:
        yyp = json.load(f)
    
    for res in yyp.get("resources", []):
        if res.get("id", {}).get("name") == name:
            return
            
    yyp["resources"].append({
        "id": {
            "name": name,
            "path": path_in_project
        }
    })
    
    with open(YYP_PATH, 'w', encoding='utf-8') as f:
        json.dump(yyp, f, indent=2)

def create_path(name, points):
    folder_path = os.path.join(PROJECT_DIR, "paths", name)
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
        
    yy_path = os.path.join(folder_path, f"{name}.yy")
    
    path_data = {
      "$GMPath": "",
      "%Name": name,
      "closed": False,
      "kind": 0,
      "name": name,
      "parent": {
        "name": "Phats",
        "path": "folders/Phats.yy"
      },
      "points": points,
      "precision": 4,
      "resourceType": "GMPath",
      "resourceVersion": "2.0"
    }
    
    with open(yy_path, 'w', encoding='utf-8') as f:
        json.dump(path_data, f, indent=2)
        
    add_resource(name, "GMPath", f"paths/{name}/{name}.yy")

def create_room(name):
    folder_path = os.path.join(PROJECT_DIR, "rooms", name)
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
        
    yy_path = os.path.join(folder_path, f"{name}.yy")
    room1_path = os.path.join(PROJECT_DIR, "rooms", "Room1", "Room1.yy")
    
    with open(room1_path, 'r', encoding='utf-8') as f:
        room_data = json.load(f)
        
    room_data["%Name"] = name
    room_data["name"] = name
    
    # Let's fix the instances to use the current room path in "path"
    for layer in room_data.get("layers", []):
        if layer.get("resourceType") == "GMRInstanceLayer":
            for inst in layer.get("instances", []):
                inst["path"] = f"rooms/{name}/{name}.yy"
                
    # Also fix the instanceCreationOrder
    for inst in room_data.get("instanceCreationOrder", []):
        inst["path"] = f"rooms/{name}/{name}.yy"
    
    with open(yy_path, 'w', encoding='utf-8') as f:
        json.dump(room_data, f, indent=2)
        
    add_resource(name, "GMRoom", f"rooms/{name}/{name}.yy")

# Puntos para Ciudad: Izquierda a Derecha, baja, derecha
pts_ciudad = [
    {"speed":100.0,"x":0.0,"y":128.0},
    {"speed":100.0,"x":256.0,"y":128.0},
    {"speed":100.0,"x":256.0,"y":384.0},
    {"speed":100.0,"x":1024.0,"y":384.0},
    {"speed":100.0,"x":1024.0,"y":128.0},
    {"speed":100.0,"x":1366.0,"y":128.0}
]

# Puntos para Bosque
pts_bosque = [
    {"speed":100.0,"x":0.0,"y":600.0},
    {"speed":100.0,"x":384.0,"y":600.0},
    {"speed":100.0,"x":384.0,"y":200.0},
    {"speed":100.0,"x":768.0,"y":200.0},
    {"speed":100.0,"x":768.0,"y":600.0},
    {"speed":100.0,"x":1366.0,"y":600.0}
]

# Puntos para Mar
pts_mar = [
    {"speed":100.0,"x":0.0,"y":300.0},
    {"speed":100.0,"x":500.0,"y":300.0},
    {"speed":100.0,"x":500.0,"y":500.0},
    {"speed":100.0,"x":800.0,"y":500.0},
    {"speed":100.0,"x":800.0,"y":300.0},
    {"speed":100.0,"x":1366.0,"y":300.0}
]

create_path("Path_Ciudad", pts_ciudad)
create_path("Path_Bosque", pts_bosque)
create_path("Path_Mar", pts_mar)

create_room("Rm_Ciudad")
create_room("Rm_Bosque")
create_room("Rm_Mar")
