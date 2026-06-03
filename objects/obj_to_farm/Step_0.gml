if (cooldown > 0) { cooldown -= 1; exit; }
var _dist_x = abs((x + (sprite_width / 2)) - obj_player.x);
var _dist_y = abs((y + (sprite_height / 2)) - obj_player.y);
if (_dist_x < (sprite_width / 2) + 20 && _dist_y < (sprite_height / 2) + 60) {
    global.target_door = "from_city"; // Báo hiệu cho room mới biết ta đến từ city
    room_goto(target_room); 
}