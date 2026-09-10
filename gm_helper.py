import json
import os

PROJECT_DIR = r"c:\Users\prado\GameMakerProjects\BRAINROT DEFENCE 1"
YYP_PATH = os.path.join(PROJECT_DIR, "BRAINROT DEFENCE 1.yyp")

def ensure_folders():
    with open(YYP_PATH, 'r', encoding='utf-8') as f:
        yyp = json.load(f)
    
    folders_dir = os.path.join(PROJECT_DIR, "folders")
    if not os.path.exists(folders_dir):
        os.makedirs(folders_dir)

    for folder in yyp.get("Folders", []):
        folder_path = folder.get("folderPath")
        if folder_path:
            full_path = os.path.join(PROJECT_DIR, folder_path)
            if not os.path.exists(full_path):
                name = folder.get("name")
                folder_data = {
                    "$GMFolder": "",
                    "%Name": name,
                    "folderPath": folder_path,
                    "name": name,
                    "resourceType": "GMFolder",
                    "resourceVersion": "2.0"
                }
                with open(full_path, 'w', encoding='utf-8') as ff:
                    json.dump(folder_data, ff, indent=2)

def add_resource(name, type_str, path_in_project):
    with open(YYP_PATH, 'r', encoding='utf-8') as f:
        yyp = json.load(f)
    
    # Check if resource exists
    for res in yyp.get("resources", []):
        if res.get("id", {}).get("name") == name:
            return # Already exists
            
    # Add resource
    yyp["resources"].append({
        "id": {
            "name": name,
            "path": path_in_project
        }
    })
    
    with open(YYP_PATH, 'w', encoding='utf-8') as f:
        json.dump(yyp, f, indent=2)

ensure_folders()
