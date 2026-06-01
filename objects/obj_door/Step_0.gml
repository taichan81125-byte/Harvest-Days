// ==========================================
// KIỂM TRA VA CHẠM VỚI PLAYER ĐỂ CHUYỂN PHÒNG
// ==========================================
if (cooldown > 0) {
    cooldown -= 1;
    exit;
}

if (place_meeting(x, y, obj_player)) {
    // Đặt vị trí player ở room mới TRƯỚC KHI chuyển
    obj_player.x = target_x;
    obj_player.y = target_y;
    room_goto(target_room);
}
