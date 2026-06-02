// ==========================================
// KIỂM TRA VA CHẠM VỚI PLAYER ĐỂ CHUYỂN PHÒNG
// ==========================================

// --- BẮT ĐẦU: LƯU TỌA ĐỘ GỐC VÀ DỊCH CHUYỂN THEO MÙA ---
if (!variable_instance_exists(id, "initialized")) {
    base_x = x;
    base_y = y;
    base_target_x = target_x;
    base_target_y = target_y;
    
    // Độ lệch mặc định vào mùa xuân (96 pixel sang phải). Bạn có thể đổi số này.
    if (!variable_instance_exists(id, "spring_offset_x")) spring_offset_x = 96; 
    if (!variable_instance_exists(id, "spring_target_offset_x")) spring_target_offset_x = 96;
    
    initialized = true;
}

var _season = 1; // Mặc định là Hạ
if (instance_exists(obj_game_manager)) {
    _season = obj_game_manager.current_season;
}

// Nếu là mùa Xuân (0)
if (_season == 0) { 
    if (room == rm_farm) {
        // Đang ở ngoài farm: Cửa ngoài farm dịch chuyển, điểm bung vào nhà GIỮ NGUYÊN
        x = base_x + spring_offset_x;
        target_x = base_target_x;
    } else {
        // Đang ở trong nhà (rm_house): Cửa trong nhà GIỮ NGUYÊN, điểm bung ra ngoài farm DỊCH CHUYỂN
        x = base_x;
        target_x = base_target_x + spring_target_offset_x;
    }
} else { 
    x = base_x;
    target_x = base_target_x;
}
// --- KẾT THÚC: DỊCH CHUYỂN THEO MÙA ---
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
