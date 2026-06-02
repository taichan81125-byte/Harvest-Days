if (cooldown > 0) { cooldown -= 1; exit; }
if (place_meeting(x, y, obj_player)) { 
    global.target_door = "from_farm"; // Báo hiệu cho room mới biết ta đến từ farm
    room_goto(target_room); 
}