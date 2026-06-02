// Tránh tạo bản sao khi quay lại phòng có player trong Room Editor
if (instance_number(obj_player) > 1) {
    instance_destroy();
    exit;
}

// --- DI CHUYỂN VÀ HƯỚNG MẶT ---
move_speed = 4;
base_speed = 4;     // Lưu lại tốc độ gốc để thay đổi khi bị đói
facing_dir = 270;   // Mặc định mới vào game là nhìn xuống (0: Phải, 90: Lên, 180: Trái, 270: Xuống)

// --- HOẠT ẢNH (ANIMATION) ---
local_frame = 0;    // Biến đếm khung hình bước chân cho nhân vật
action_timer = 0;   // Biến đếm thời gian vung công cụ (0 thì cầm tĩnh, > 0 thì vung)

// --- HỆ THỐNG TÚI ĐỒ VÀ KINH TẾ ---
coins = 100;         // Số tiền khởi nghiệp
selected_slot = 0;  // Ô túi đồ đang được chọn (từ 0 đến 9)
item_popup_timer = 0; // Bộ đếm thời gian hiển thị tên vật phẩm khi đổi ô

// Mảng 10 ô túi đồ. Số -1 nghĩa là Ô Trống.
inventory = [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
// Mảng 10 ô chứa SỐ LƯỢNG vật phẩm tương ứng
inventory_count = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

// --- HỆ THỐNG SINH TỒN ---
hunger = 100;       // Thanh thức ăn (Tối đa 100)
hp = 3;             // ĐÃ ĐỔI TỪ HEALTH THÀNH HP (Máu - Tối đa 3 trái tim)
hp_timer = 0;       // Bộ đếm thời gian để trừ máu khi đói

// --- HỆ THỐNG TƯƠNG TÁC BẰNG CHUỘT (GRID INTERACTION) ---
mouse_tile_x = 0;
mouse_tile_y = 0;
is_action_valid = false;
is_mouse_in_reach = false;