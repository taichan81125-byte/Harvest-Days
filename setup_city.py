import re, os, shutil

yyp_path = 'd:/Harvest-Days/HarvestDays.yyp'
with open(yyp_path, 'r', encoding='utf-8') as f:
    data = f.read()

def add_resource(data, name, path_str):
    if name in data: return data
    new_res = '    {"id":{"name":"' + name + '","path":"' + path_str + '",},},\n'
    return re.sub(r'("resources":\[\n)', r'\g<1>' + new_res, data)

data = add_resource(data, 'rm_city', 'rooms/rm_city/rm_city.yy')
data = add_resource(data, 'obj_to_city', 'objects/obj_to_city/obj_to_city.yy')
data = add_resource(data, 'obj_to_farm', 'objects/obj_to_farm/obj_to_farm.yy')

def add_room_node(data, name, path_str):
    if name in data.split('"RoomOrderNodes"')[1]: return data
    new_node = '    {"roomId":{"name":"' + name + '","path":"' + path_str + '",},},\n'
    return re.sub(r'("RoomOrderNodes":\[\n)', r'\g<1>' + new_node, data)

data = add_room_node(data, 'rm_city', 'rooms/rm_city/rm_city.yy')

with open(yyp_path, 'w', encoding='utf-8') as f:
    f.write(data)

# Copy obj_door to obj_to_city and obj_to_farm
os.makedirs('d:/Harvest-Days/objects/obj_to_city', exist_ok=True)
os.makedirs('d:/Harvest-Days/objects/obj_to_farm', exist_ok=True)

with open('d:/Harvest-Days/objects/obj_door/obj_door.yy', 'r', encoding='utf-8') as f:
    door_str = f.read()

with open('d:/Harvest-Days/objects/obj_to_city/obj_to_city.yy', 'w', encoding='utf-8') as f:
    f.write(door_str.replace('obj_door', 'obj_to_city'))
    
with open('d:/Harvest-Days/objects/obj_to_farm/obj_to_farm.yy', 'w', encoding='utf-8') as f:
    f.write(door_str.replace('obj_door', 'obj_to_farm'))

# Create scripts for them
with open('d:/Harvest-Days/objects/obj_to_city/Create_0.gml', 'w', encoding='utf-8') as f:
    f.write('target_room = rm_city;\ntarget_x = 2000;\ntarget_y = 1500;\nimage_alpha = 0;\ncooldown = 30;')
with open('d:/Harvest-Days/objects/obj_to_city/Step_0.gml', 'w', encoding='utf-8') as f:
    f.write('if (cooldown > 0) { cooldown -= 1; exit; }\nif (place_meeting(x, y, obj_player)) { obj_player.x = target_x; obj_player.y = target_y; room_goto(target_room); }')

with open('d:/Harvest-Days/objects/obj_to_farm/Create_0.gml', 'w', encoding='utf-8') as f:
    f.write('target_room = rm_farm;\ntarget_x = 3800;\ntarget_y = 1500;\nimage_alpha = 0;\ncooldown = 30;')
with open('d:/Harvest-Days/objects/obj_to_farm/Step_0.gml', 'w', encoding='utf-8') as f:
    f.write('if (cooldown > 0) { cooldown -= 1; exit; }\nif (place_meeting(x, y, obj_player)) { obj_player.x = target_x; obj_player.y = target_y; room_goto(target_room); }')

# Copy room
os.makedirs('d:/Harvest-Days/rooms/rm_city', exist_ok=True)
with open('d:/Harvest-Days/rooms/rm_farm/rm_farm.yy', 'r', encoding='utf-8') as f:
    rm_str = f.read()
rm_str = rm_str.replace('rm_farm', 'rm_city')
rm_str = re.sub(r'"instances":\[.*?\]', '"instances":[]', rm_str, flags=re.DOTALL)
rm_str = re.sub(r'"instanceCreationOrder":\[.*?\]', '"instanceCreationOrder":[]', rm_str, flags=re.DOTALL)

with open('d:/Harvest-Days/rooms/rm_city/rm_city.yy', 'w', encoding='utf-8') as f:
    f.write(rm_str)

print("Done")
