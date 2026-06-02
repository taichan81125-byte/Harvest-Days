import json, uuid, os, re

proj_dir = 'd:/Harvest-Days'

def read_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        s = f.read()
    s = re.sub(r',\s*}', '}', s)
    s = re.sub(r',\s*\]', ']', s)
    return json.loads(s)

def write_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def generate_solid_inst(name, x, y, sx, sy):
    return {
      "$GMRInstance": "v4",
      "%Name": name,
      "colour": 4294967295,
      "empty": False,
      "frozen": False,
      "hasCreationCode": False,
      "ignore": False,
      "imageIndex": 0,
      "imageSpeed": 1.0,
      "inheritCode": False,
      "inheritedItemId": None,
      "inheritItemSettings": False,
      "isDnd": False,
      "name": name,
      "objectId": {
        "name": "obj_solid",
        "path": "objects/obj_solid/obj_solid.yy"
      },
      "properties": [],
      "resourceType": "GMRInstance",
      "resourceVersion": "2.0",
      "rotation": 0.0,
      "scaleX": sx,
      "scaleY": sy,
      "x": x,
      "y": y
    }

def add_borders(room_name):
    room_path = os.path.join(proj_dir, 'rooms', room_name, f"{room_name}.yy")
    data = read_json(room_path)
    
    # 4 walls, put them INSIDE the room bounds
    w = 4000
    h = 3000
    thick = 64
    sx_horiz = w / thick
    sy_vert = h / thick
    
    walls = [
        generate_solid_inst(f"inst_{uuid.uuid4().hex[:8].upper()}", 0.0, 0.0, sx_horiz, 1.0),
        generate_solid_inst(f"inst_{uuid.uuid4().hex[:8].upper()}", 0.0, float(h - thick), sx_horiz, 1.0),
        generate_solid_inst(f"inst_{uuid.uuid4().hex[:8].upper()}", 0.0, 0.0, 1.0, sy_vert),
        generate_solid_inst(f"inst_{uuid.uuid4().hex[:8].upper()}", float(w - thick), 0.0, 1.0, sy_vert)
    ]
    
    # Find exact 'Instances' layer
    for l in data['layers']:
        if l.get('name') == 'Instances':
            # Remove any existing huge solids just in case
            new_insts = []
            for inst in l.get('instances', []):
                if inst['objectId']['name'] == 'obj_solid' and (inst['scaleX'] > 20 or inst['scaleY'] > 20):
                    pass # Skip
                else:
                    new_insts.append(inst)
            new_insts.extend(walls)
            l['instances'] = new_insts
            break
            
    for w_inst in walls:
        data.setdefault('instanceCreationOrder', []).append({"name": w_inst["name"], "path": f"rooms/{room_name}/{room_name}.yy"})
        
    write_json(room_path, data)
    print(f"Added INSIDE borders to {room_name}")

add_borders('rm_farm')
add_borders('rm_city')
