// 1. TẠO HIỆU ỨNG CHỮ NHẤP NHÁY
text_alpha += 0.02 * fade_dir;

if (text_alpha <= 0.2) {
    fade_dir = 1; // Rõ dần lên
} else if (text_alpha >= 1.0) {
    fade_dir = -1; // Mờ dần đi
}

// 2. NHẬN LỆNH ĐỂ VÀO MÀN HÌNH CHỌN SLOT BẰNG BÀN PHÍM
// Dùng phím Space hoặc Enter đều được
if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
    room_goto(rm_load_game);
}

// 3. NHẬN LỆNH CLICK CHUỘT LÊN CÁC NÚT BẤM (GIAO DIỆN MỚI)
if (mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    // Nút BẮT ĐẦU (Nằm ở trên)
    if (_mx >= 500 && _mx <= 780 && _my >= 350 && _my <= 440) {
        room_goto(rm_load_game);
    }
    
    // Nút THOÁT (Nằm ở dưới)
    if (_mx >= 500 && _mx <= 780 && _my >= 450 && _my <= 540) {
        game_end();
    }
}