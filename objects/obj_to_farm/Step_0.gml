if (cooldown > 0) { cooldown -= 1; exit; }
if (place_meeting(x, y, obj_player)) { 
    global.target_door = "from_city"; // Báo hiệu cho room mới biết ta đến từ city
    room_goto(target_room); 
}