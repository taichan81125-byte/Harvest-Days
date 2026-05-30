// 1. LẤY THÔNG TIN VẬT PHẨM ĐANG CẦM
var _current_item = inventory[selected_slot];

// NẾU KHÔNG CẦM GÌ, CHỈ VẼ NHÂN VẬT VÀ THOÁT LUÔN
if (_current_item == -1) {
draw_self();
exit;
}

// 2. TÍNH TOÁN VỊ TRÍ, GÓC VÀ KÍCH THƯỚC KHI CẦM ĐỒ
var _spr = obj_game_manager.item_sprites[_current_item];
var _item_x = x;
var _item_y = y; // Khởi tạo tạm
var _angle = 0;

// ========================================================
// TÙY CHỈNH ĐỘ TO NHỎ CHO TỪNG LOẠI ĐỒ VẬT
// ========================================================
var _base_scale = 0.8; // Mặc định cho Công cụ (Cuốc, Bình tưới) và Đồ trang trí

if (_current_item == 7) {
// Quả Cà Chua -> Thu nhỏ lại cho vừa tay
_base_scale = 0.4;
}
else if (_current_item == 2 || _current_item == 3) {
// Hạt giống -> Cũng thu nhỏ lại cho vừa tay
_base_scale = 0.5;
}

var _scale_x = _base_scale;

var _scale_y = _base_scale;

// ========================================================
// CHỈNH SỬA TỌA ĐỘ VÀ GÓC THEO HƯỚNG MẶT
// ========================================================
// Vì tâm nhân vật ở dưới gót chân, ta trừ đi số lớn (~35) để kéo vật phẩm lên ngang tay
if (facing_dir == 270) { // Nhìn Xuống
_item_x = x - 12;    // Đưa sang tay phải
_item_y = y - 30;    // Kéo lên ngang bụng
_angle = (action_timer > 0) ? -60 : -15; // Góc vung tay
}
else if (facing_dir == 90) { // Nhìn Lên
_item_x = x + 12;
_item_y = y - 40;    // Kéo lên cao hơn đằng sau lưng
_angle = (action_timer > 0) ? 60 : 15;
}
else if (facing_dir == 0) { // Nhìn Phải
_item_x = x + 20;    // Đưa ra trước mặt
_item_y = y - 35;    // Kéo lên ngang tay
_angle = (action_timer > 0) ? -60 : -15;
}
else if (facing_dir == 180) { // Nhìn Trái
_item_x = x - 20;    // Đưa ra trước mặt
_item_y = y - 35;    // Kéo lên ngang tay
_angle = (action_timer > 0) ? -60 : -15;
_scale_x = -_base_scale; // LẬT NGƯỢC HÌNH ẢNH CÔNG CỤ
}

// Tinh chỉnh riêng cho Hạt giống (ID 2, 3), Đồ trang trí (ID 4,5,6) và Nông sản (ID 7)
// Những món đồ này khi cầm trên tay sẽ không bị xoay chéo như cái cuốc
if (_current_item >= 2) {
_angle = 0;

// Khi bấm Space, đồ vật chỉ nhún xuống một chút chứ không vung mạnh như cuốc
if (action_timer > 0) {
    _item_y += 5; 
}


}

// 3. VẼ THEO THỨ TỰ TRƯỚC-SAU ĐỂ TRÁNH LỖI ĐÈ HÌNH
if (facing_dir == 90) {
// Nếu nhìn lên, Công cụ bị khuất sau lưng -> VẼ CÔNG CỤ TRƯỚC, NHÂN VẬT SAU
draw_sprite_ext(_spr, 0, _item_x, _item_y, _scale_x, _scale_y, _angle, c_white, 1);
draw_self();
}
else {
// Các hướng khác: VẼ NHÂN VẬT TRƯỚC, CÔNG CỤ ĐÈ LÊN TAY SAU
draw_self();
draw_sprite_ext(_spr, 0, _item_x, _item_y, _scale_x, _scale_y, _angle, c_white, 1);
}