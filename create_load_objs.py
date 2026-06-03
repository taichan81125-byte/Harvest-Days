import os
import json
import re

YYP_PATH = "HarvestDays.yyp"

objects_to_create = [
    {
        "name": "obj_ui_load_slot",
        "variables": [
            {"name": "slot_index", "type": 1, "value": "0"}
        ]
    },
    {
        "name": "obj_ui_delete_btn",
        "variables": [
            {"name": "slot_index", "type": 1, "value": "0"}
        ]
    },
    {
        "name": "obj_ui_back_btn",
        "variables": []
    }
]

def add_objects_to_yyp(yyp_path, objects):
    with open(yyp_path, 'r', encoding='utf-8') as f:
        yyp_str = f.read()
        
    changed = False
    for obj in objects:
        obj_name = obj["name"]
        if f'"{obj_name}"' not in yyp_str:
            new_res = '    {"id":{"name":"' + obj_name + '","path":"objects/' + obj_name + '/' + obj_name + '.yy",},},\n'
            yyp_str = re.sub(r'("resources":\s*\[\n)', r'\g<1>' + new_res, yyp_str)
            changed = True
            print(f"Added {obj_name} to yyp")
            
    if changed:
        with open(yyp_path, 'w', encoding='utf-8') as f:
            f.write(yyp_str)

def create_object_files(obj):
    obj_name = obj["name"]
    obj_dir = os.path.join("objects", obj_name)
    os.makedirs(obj_dir, exist_ok=True)
    
    yy_path = os.path.join(obj_dir, f"{obj_name}.yy")
    
    var_defs = []
    for var in obj.get("variables", []):
        var_defs.append({
            "$GMObjectProperty": "v1",
            "%Name": var["name"],
            "filters": [],
            "listItems": [],
            "multiselect": False,
            "name": var["name"],
            "rangeEnabled": False,
            "rangeMax": 10.0,
            "rangeMin": 0.0,
            "resourceType": "GMObjectProperty",
            "resourceVersion": "2.0",
            "value": var["value"],
            "varType": var["type"]
        })
    
    yy_data = {
      "$GMObject": "",
      "%Name": obj_name,
      "eventList": [],
      "managed": True,
      "name": obj_name,
      "overriddenProperties": [],
      "parent": {
        "name": "Objects",
        "path": "folders/Objects.yy"
      },
      "parentObjectId": None,
      "persistent": False,
      "physicsAngularDamping": 0.1,
      "physicsDensity": 0.5,
      "physicsFriction": 0.2,
      "physicsGroup": 1,
      "physicsKinematic": False,
      "physicsLinearDamping": 0.1,
      "physicsObject": False,
      "physicsRestitution": 0.1,
      "physicsSensor": False,
      "physicsShape": 1,
      "physicsShapePoints": [],
      "physicsStartAwake": True,
      "properties": var_defs,
      "resourceType": "GMObject",
      "resourceVersion": "2.0",
      "solid": False,
      "spriteId": {
        "name": "spr_solid",
        "path": "sprites/spr_solid/spr_solid.yy"
      },
      "spriteMaskId": None,
      "visible": True
    }
    
    with open(yy_path, 'w', encoding='utf-8') as f:
        json.dump(yy_data, f, indent=2)

if __name__ == "__main__":
    for obj in objects_to_create:
        create_object_files(obj)
        
    add_objects_to_yyp(YYP_PATH, objects_to_create)
    print("Objects created successfully.")
