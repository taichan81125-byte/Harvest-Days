import json, uuid, os, shutil, re

proj_dir = 'd:/Harvest-Days'
yyp_path = os.path.join(proj_dir, 'HarvestDays.yyp')

# Helper to read JSON that might have trailing commas
def read_json(path):
    with open(path, 'r', encoding='utf-8') as f:
        s = f.read()
    s = re.sub(r',\s*}', '}', s)
    s = re.sub(r',\s*\]', ']', s)
    return json.loads(s)

def write_json(path, data):
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def generate_sprite_json(name, width, height):
    frame_uuid = str(uuid.uuid4())
    layer_uuid = str(uuid.uuid4())
    
    sprite = {
      "$GMSprite": "v2",
      "%Name": name,
      "bboxMode": 0,
      "bbox_bottom": height - 1,
      "bbox_left": 0,
      "bbox_right": width - 1,
      "bbox_top": 0,
      "collisionKind": 1,
      "collisionTolerance": 0,
      "DynamicTexturePage": False,
      "edgeFiltering": False,
      "For3D": False,
      "frames": [
        {"$GMSpriteFrame":"v1","%Name":frame_uuid,"name":frame_uuid,"resourceType":"GMSpriteFrame","resourceVersion":"2.0",}
      ],
      "gridX": 0,
      "gridY": 0,
      "height": height,
      "HTile": False,
      "layers": [
        {"$GMImageLayer":"","%Name":layer_uuid,"blendMode":0,"displayName":"default","isLocked":False,"name":layer_uuid,"opacity":100.0,"resourceType":"GMImageLayer","resourceVersion":"2.0","visible":True,}
      ],
      "name": name,
      "nineSlice": None,
      "origin": 0,
      "parent": {
        "name": "Sprites",
        "path": "folders/Sprites.yy"
      },
      "preMultiplyAlpha": False,
      "resourceType": "GMSprite",
      "resourceVersion": "2.0",
      "sequence": {
        "$GMSequence": "v1",
        "%Name": name,
        "autoRecord": True,
        "backdropHeight": 768,
        "backdropImageOpacity": 0.5,
        "backdropImagePath": "",
        "backdropWidth": 1366,
        "backdropXOffset": 0.0,
        "backdropYOffset": 0.0,
        "events": {
          "$KeyframeStore<MessageEventKeyframe>": "",
          "Keyframes": [],
          "resourceType": "KeyframeStore<MessageEventKeyframe>",
          "resourceVersion": "2.0"
        },
        "eventStubScript": None,
        "eventToFunction": {},
        "length": 1.0,
        "lockOrigin": False,
        "moments": {
          "$KeyframeStore<MomentsEventKeyframe>": "",
          "Keyframes": [],
          "resourceType": "KeyframeStore<MomentsEventKeyframe>",
          "resourceVersion": "2.0"
        },
        "name": name,
        "playback": 1,
        "playbackSpeed": 30.0,
        "playbackSpeedType": 0,
        "resourceType": "GMSequence",
        "resourceVersion": "2.0",
        "showBackdrop": True,
        "showBackdropImage": False,
        "timeUnits": 1,
        "tracks": [
          {"$GMSpriteFramesTrack":"","builtinName":0,"events":[],"inheritsTrackColour":True,"interpolation":1,"isCreationTrack":False,"keyframes":{"$KeyframeStore<SpriteFrameKeyframe>":"","Keyframes":[
                {"$Keyframe<SpriteFrameKeyframe>":"","Channels":{
                    "0":{"$SpriteFrameKeyframe":"","Id":{"name":frame_uuid,"path":f"sprites/{name}/{name}.yy",},"resourceType":"SpriteFrameKeyframe","resourceVersion":"2.0",},
                  },"Disabled":False,"id":str(uuid.uuid4()),"IsCreationKey":False,"Key":0.0,"Length":1.0,"resourceType":"Keyframe<SpriteFrameKeyframe>","resourceVersion":"2.0","Stretch":False,},
              ],"resourceType":"KeyframeStore<SpriteFrameKeyframe>","resourceVersion":"2.0",},"modifiers":[],"name":"frames","resourceType":"GMSpriteFramesTrack","resourceVersion":"2.0","spriteId":None,"trackColour":0,"tracks":[],"traits":0,}
        ],
        "visibleRange": None,
        "volume": 1.0,
        "xorigin": 0,
        "yorigin": 0
      },
      "swatchColours": None,
      "swfPrecision": 0.5,
      "textureGroupId": {
        "name": "Default",
        "path": "texturegroups/Default"
      },
      "type": 0,
      "VTile": False,
      "width": width
    }
    return sprite, frame_uuid, layer_uuid

def create_sprite(name, source_img, width, height):
    sprite_dir = os.path.join(proj_dir, 'sprites', name)
    os.makedirs(sprite_dir, exist_ok=True)
    
    sprite_json, frame_uuid, layer_uuid = generate_sprite_json(name, width, height)
    write_json(os.path.join(sprite_dir, f"{name}.yy"), sprite_json)
    
    shutil.copy(source_img, os.path.join(sprite_dir, f"{frame_uuid}.png"))
    
    layers_dir = os.path.join(sprite_dir, 'layers', frame_uuid)
    os.makedirs(layers_dir, exist_ok=True)
    # create empty image for layer just in case, or just copy the main image there
    shutil.copy(source_img, os.path.join(layers_dir, f"{layer_uuid}.png"))
    
    # Add to yyp
    with open(yyp_path, 'r', encoding='utf-8') as f:
        yyp_str = f.read()
    
    if name not in yyp_str:
        new_res = '    {"id":{"name":"' + name + '","path":"sprites/' + name + '/' + name + '.yy",},},\n'
        yyp_str = re.sub(r'("resources":\[\n)', r'\g<1>' + new_res, yyp_str)
        with open(yyp_path, 'w', encoding='utf-8') as f:
            f.write(yyp_str)

create_sprite('spr_farm_bg', os.path.join(proj_dir, 'datafiles', 'ha.png'), 1568, 1003)
create_sprite('spr_city_bg', os.path.join(proj_dir, 'datafiles', 'city_ha.png'), 1568, 1003)

def update_room(room_name, sprite_name):
    room_path = os.path.join(proj_dir, 'rooms', room_name, f"{room_name}.yy")
    data = read_json(room_path)
    
    # Remove Tiles_1, Tiles_2, Tiles_3
    new_layers = []
    for l in data['layers']:
        if l.get('name') not in ['Tiles_1', 'Tiles_2', 'Tiles_3']:
            new_layers.append(l)
    
    # Check if we already have a background layer
    has_bg = False
    for l in new_layers:
        if l.get('resourceType') == 'GMRBackgroundLayer' and l.get('name') == 'Background_Map':
            has_bg = True
            break
            
    if not has_bg:
        bg_layer = {
          "$GMRBackgroundLayer": "",
          "%Name": "Background_Map",
          "animationFPS": 15.0,
          "animationSpeedType": 0,
          "colour": 4294967295,
          "depth": 800, # Put it behind everything
          "effectEnabled": True,
          "effectType": None,
          "gridX": 32,
          "gridY": 32,
          "hierarchyFrozen": False,
          "hspeed": 0.0,
          "htiled": False,
          "inheritLayerDepth": False,
          "inheritLayerSettings": False,
          "inheritSubLayers": True,
          "inheritVisibility": True,
          "layers": [],
          "name": "Background_Map",
          "properties": [],
          "resourceType": "GMRBackgroundLayer",
          "resourceVersion": "2.0",
          "spriteId": {
            "name": sprite_name,
            "path": f"sprites/{sprite_name}/{sprite_name}.yy"
          },
          "stretch": True,
          "userdefinedAnimFPS": False,
          "userdefinedDepth": False,
          "visible": True,
          "vspeed": 0.0,
          "vtiled": False,
          "x": 0,
          "y": 0
        }
        new_layers.append(bg_layer)
    
    data['layers'] = new_layers
    write_json(room_path, data)

update_room('rm_farm', 'spr_farm_bg')
update_room('rm_city', 'spr_city_bg')

print("Done")
