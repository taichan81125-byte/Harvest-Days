// ==========================================
// KIỂM TRA VA CHẠM VỚI PLAYER ĐỂ CHUYỂN PHÒNG
// ==========================================

// (Đã bỏ logic dịch chuyển cửa theo mùa vì gây lỗi lệch vị trí)
if (cooldown > 0) {
    cooldown -= 1;
    exit;
}

// Kiểm tra va chạm bằng distance cho dễ thay vì phụ thuộc vào bounding box bị thu nhỏ của player
var _dist_x = abs((x + (sprite_width / 2)) - obj_player.x);
var _dist_y = abs((y + (sprite_height / 2)) - obj_player.y);

// Nếu người chơi ở đủ gần tâm của cửa (chỉ tính chính xác bên trong phạm vi cửa)
if (_dist_x <= (sprite_width / 2) && _dist_y <= (sprite_height / 2)) {
    // Đặt vị trí player ở room mới TRƯỚC KHI chuyển
    obj_player.x = target_x;
    obj_player.y = target_y;
    room_goto(target_room);
}
