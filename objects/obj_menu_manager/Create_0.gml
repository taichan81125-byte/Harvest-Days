// Đổi con trỏ chuột sang sprite mới và ẩn con trỏ chuột hệ thống ngay từ lúc mở game
// Xóa cursor_sprite để vẽ thủ công to hơn
window_set_cursor(cr_none);

display_set_gui_size(1280, 720);

// Biến dùng để tạo hiệu ứng nhấp nháy (độ mờ) cho dòng chữ "Nhấn Space"
text_alpha = 1.0;
fade_dir = -1; // -1 là đang mờ đi, 1 là đang rõ lên

// Khai báo biến toàn cục để báo cho game biết người chơi muốn "Chơi Mới" hay "Chơi Tiếp"
global.load_game = false; 
