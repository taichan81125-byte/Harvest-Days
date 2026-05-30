// ... existing code ...
// 1. TẠO HIỆU ỨNG CHỮ NHẤP NHÁY
text_alpha += 0.02 * fade_dir;

if (text_alpha <= 0.2) {
fade_dir = 1; // Rõ dần lên
} else if (text_alpha >= 1.0) {
fade_dir = -1; // Mờ dần đi
}

// 2. NHẬN LỆNH ĐỂ VÀO MÀN HÌNH CHỌN SLOT
// Dùng phím Space hoặc Enter đều được
if (keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_enter)) {
room_goto(rm_load_game);
}