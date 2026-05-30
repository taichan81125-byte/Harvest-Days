// =======================================================
// A. NẾU ĐANG TRONG CHẾ ĐỘ NHẬP TÊN BẰNG BÀN PHÍM
// =======================================================
if (is_typing == true) {
    new_name = keyboard_string; // Nhận phím người chơi gõ vào
    
    // Giới hạn tên dài tối đa 12 ký tự
    if (string_length(new_name) > 12) {
        new_name = string_copy(new_name, 1, 12);
        keyboard_string = new_name;
    }
    
    // Khi nhấn Enter -> Xác nhận tên và vào game
    if (keyboard_check_pressed(vk_enter) && new_name != "") {
        global.current_save_file = slot_files[typing_slot]; // Nhớ file sẽ lưu
        global.player_name = new_name + "_farm";            // Tự động thêm đuôi _farm
        global.is_new_game = true;                          // Đánh dấu là chơi mới
        room_goto(rm_farm);                                 // Bắt đầu game!
    }
    
    // Bấm ESC để hủy nhập tên
    if (keyboard_check_pressed(vk_escape)) {
        is_typing = false;
    }
    exit; // Thoát sự kiện Step, chặn click chuột lung tung khi đang gõ
}

// =======================================================
// B. KIỂM TRA CLICK CHUỘT VÀO CÁC NÚT SLOT BÌNH THƯỜNG
// =======================================================
if (mouse_check_button_pressed(mb_left)) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    var _start_x = 340;
    var _start_y = 150;
    
    for(var i = 0; i < 4; i++) {
        var _btn_y = _start_y + (i * 120);
        
        // 1. KIỂM TRA CLICK VÀO NÚT XÓA (MÀU ĐỎ)
        if (slot_names[i] != "Trống") {
            if (_mx > _start_x + 500 && _mx < _start_x + 580 && _my > _btn_y + 25 && _my < _btn_y + 75) {
                if (file_exists(slot_files[i])) file_delete(slot_files[i]); // Xóa file trong ổ cứng
                slot_names[i] = "Trống"; // Reset giao diện
                slot_days[i] = 0;
                continue; // Bỏ qua phần click bên dưới
            }
        }
        
        // 2. KIỂM TRA CLICK VÀO KHUNG CHỌN SLOT
        if (_mx > _start_x && _mx < _start_x + 480 && _my > _btn_y && _my < _btn_y + 100) {
            // Nếu Slot trống -> Bật chế độ gõ phím
            if (slot_names[i] == "Trống") {
                is_typing = true;
                typing_slot = i;
                keyboard_string = "";
                new_name = "";
            } 
            // Nếu Slot đã có người chơi -> Bật game luôn (Load Data)
            else {
                global.current_save_file = slot_files[i];
                global.player_name = slot_names[i];
                global.is_new_game = false; // Đánh dấu là Load Game
                room_goto(rm_farm);
            }
        }
    }
    
    // 3. KIỂM TRA CLICK NÚT TRỞ VỀ MENU
    if (_mx > 20 && _mx < 150 && _my > 20 && _my < 70) {
        room_goto(rm_menu);
    }
}