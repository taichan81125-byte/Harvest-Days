// ========================================================
// BƯỚC ĐỆM LOAD GAME LÚC VỪA VÀO PHÒNG (SAU KHI CHỌN SLOT)
// ========================================================

// LỚP BẢO VỆ: Nếu test game chạy thẳng vào rm_farm mà chưa qua Menu
if (!variable_global_exists("is_new_game")) {
    global.is_new_game = true;
    global.player_name = "Test_Farm";
    global.current_save_file = "slot1.ini";
}

if (global.is_new_game == true) {
    // Trường hợp 1: Người chơi bấm vào Slot Trống và vừa gõ tên xong
    owner_name = global.player_name;
    show_debug_message("Bắt đầu Game Mới với tài khoản: " + owner_name);
} 
else {
    // Trường hợp 2: Người chơi bấm vào Slot đã có tên (Chơi tiếp)
    load_game(global.current_save_file);
}