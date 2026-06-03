import json
import os
import re

room_path = "d:/Harvest-Days/rooms/rm_load_game/rm_load_game.yy"

with open(room_path, 'r', encoding='utf-8') as f:
    text = f.read()
    
# Remove trailing commas for json parsing
text_clean = re.sub(r',\s*}', '}', text)
text_clean = re.sub(r',\s*\]', ']', text_clean)
data = json.loads(text_clean)

# Find the instance layer
inst_layer = None
for layer in data["layers"]:
    if layer.get("name") == "Instances":
        inst_layer = layer
        break

if inst_layer:
    # Filter out old slots and delete buttons
    new_instances = []
    for inst in inst_layer["instances"]:
        obj_name = inst["objectId"]["name"]
        if obj_name not in ["obj_ui_load_slot", "obj_ui_delete_btn"]:
            new_instances.append(inst)
            
    # Add 4 slots and 4 delete buttons
    # Coordinates based on user's placement of delete buttons: 213, 341.6, 474, 601
    # Let's say slot y centers around these:
    # y = delete_y - 45
    # x = 320 for slot, 894 for delete
    
    y_centers = [213, 341.6, 474, 601]
    
    for i in range(4):
        slot_y = y_centers[i] - 50
        
        # Slot
        slot_inst = {
            "$GMRInstance": "v4",
            "%Name": f"inst_slot_{i}",
            "colour": 4294967295,
            "frozen": False,
            "hasCreationCode": False,
            "ignore": False,
            "imageIndex": 0,
            "imageSpeed": 1.0,
            "inheritCode": False,
            "inheritedItemId": None,
            "inheritItemSettings": False,
            "isDnd": False,
            "name": f"inst_slot_{i}",
            "objectId": {
                "name": "obj_ui_load_slot",
                "path": "objects/obj_ui_load_slot/obj_ui_load_slot.yy"
            },
            "properties": [
                {
                    "$GMRInstanceProperty": "v1",
                    "%Name": "slot_index",
                    "name": "slot_index",
                    "propertyId": {
                        "name": "slot_index",
                        "path": "objects/obj_ui_load_slot/obj_ui_load_slot.yy"
                    },
                    "resourceType": "GMRInstanceProperty",
                    "resourceVersion": "2.0",
                    "value": str(i)
                }
            ],
            "resourceType": "GMRInstance",
            "resourceVersion": "2.0",
            "rotation": 0.0,
            "scaleX": 8.8,
            "scaleY": 1.5,
            "x": 300.0,
            "y": slot_y
        }
        
        # Delete btn
        del_inst = {
            "$GMRInstance": "v4",
            "%Name": f"inst_del_{i}",
            "colour": 4294967295,
            "frozen": False,
            "hasCreationCode": False,
            "ignore": False,
            "imageIndex": 0,
            "imageSpeed": 1.0,
            "inheritCode": False,
            "inheritedItemId": None,
            "inheritItemSettings": False,
            "isDnd": False,
            "name": f"inst_del_{i}",
            "objectId": {
                "name": "obj_ui_delete_btn",
                "path": "objects/obj_ui_delete_btn/obj_ui_delete_btn.yy"
            },
            "properties": [
                {
                    "$GMRInstanceProperty": "v1",
                    "%Name": "slot_index",
                    "name": "slot_index",
                    "propertyId": {
                        "name": "slot_index",
                        "path": "objects/obj_ui_delete_btn/obj_ui_delete_btn.yy"
                    },
                    "resourceType": "GMRInstanceProperty",
                    "resourceVersion": "2.0",
                    "value": str(i)
                }
            ],
            "resourceType": "GMRInstance",
            "resourceVersion": "2.0",
            "rotation": 0.0,
            "scaleX": 0.8,
            "scaleY": 0.8,
            "x": 890.0,
            "y": y_centers[i] - 10
        }
        
        new_instances.append(slot_inst)
        if i != 3: # maybe add delete btn for all, but code says if i != 3
            new_instances.append(del_inst)
        
    inst_layer["instances"] = new_instances
    
    # Update order
    data["instanceCreationOrder"] = []
    for inst in new_instances:
        data["instanceCreationOrder"].append({
            "name": inst["name"],
            "path": f"rooms/rm_load_game/rm_load_game.yy"
        })
        
    # Re-add existing other instances
    for inst in new_instances:
        if inst["name"] in ["inst_46E57205", "inst_5C749E4C", "inst_648CA350"]:
             pass # They are already in new_instances

def dump_gm_json(obj):
    # Need to output standard json
    return json.dumps(obj, indent=2)

with open(room_path, 'w', encoding='utf-8') as f:
    f.write(dump_gm_json(data))
    
print("Room fixed.")
