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
var _item_y = y;
var _angle = 0;

// Lấy thông tin sprite gốc để bù trừ origin
var _spr_w = sprite_get_width(_spr);
var _spr_h = sprite_get_height(_spr);
var _spr_ox = sprite_get_xoffset(_spr);
var _spr_oy = sprite_get_yoffset(_spr);

// Tính offset để đưa "tâm thực" của sprite về đúng vị trí vẽ
// (Bù trừ cho các sprite có origin ở góc 0,0 thay vì ở giữa)
var _center_fix_x = (_spr_w / 2) - _spr_ox;
var _center_fix_y = (_spr_h / 2) - _spr_oy;

// ========================================================
// TÙY CHỈNH ĐỘ TO NHỎ CHO TỪNG LOẠI ĐỒ VẬT
// ========================================================
var _base_scale = 0.55; // Mặc định cho Công cụ

if (_current_item == 7 || _current_item == 11 || _current_item == 12) {
    // Quả Cà Chua -> Thu nhỏ lại cho vừa tay
    _base_scale = 0.35;
}
else if (_current_item == 2 || _current_item == 3) {
    // Hạt giống -> Cũng thu nhỏ lại cho vừa tay
    _base_scale = 0.4;
}
else if (_current_item >= 4 && _current_item <= 6) {
    // Đồ trang trí
    _base_scale = 0.45;
}
else if (_current_item == 8 || _current_item == 9) {
    // Phân bón, Thuốc sinh học
    _base_scale = 0.4;
}

var _scale_x = _base_scale;
var _scale_y = _base_scale;

// ========================================================
// PHÂN LOẠI: CÔNG CỤ (xoay được) vs ĐỒ VẬT (không xoay)
// ========================================================
var _is_tool = (_current_item == 0 || _current_item == 1 || _current_item == 10);

// ========================================================
// CHỈNH SỬA TỌA ĐỘ VÀ GÓC THEO HƯỚNG MẶT
// ========================================================
if (_is_tool) {
    // === CÔNG CỤ (Cuốc, Bình tưới, Liềm) ===
    if (facing_dir == 270) { // Nhìn Xuống
        _item_x = x - 5;
        _item_y = y - 30;
        _angle = (action_timer > 0) ? -100 : -45;
    }
    else if (facing_dir == 90) { // Nhìn Lên
        _item_x = x + 5;
        _item_y = y - 40;
        _angle = (action_timer > 0) ? 100 : 45;
    }
    else if (facing_dir == 0) { // Nhìn Phải
        _item_x = x + 10;
        _item_y = y - 32;
        _angle = (action_timer > 0) ? -70 : -15;
    }
    else if (facing_dir == 180) { // Nhìn Trái
        _item_x = x - 10;
        _item_y = y - 32;
        _angle = (action_timer > 0) ? 70 : 15;
        _scale_x = -_base_scale; // Lật hình theo trục ngang
    }
}
else {
    // === ĐỒ VẬT THƯỜNG (Hạt giống, Nông sản, Đồ trang trí, Phân bón) ===
    _angle = 0;
    
    if (facing_dir == 270) { // Nhìn Xuống
        _item_x = x - 8;
        _item_y = y - 28;
    }
    else if (facing_dir == 90) { // Nhìn Lên
        _item_x = x + 8;
        _item_y = y - 42;
    }
    else if (facing_dir == 0) { // Nhìn Phải
        _item_x = x + 12;
        _item_y = y - 32;
    }
    else if (facing_dir == 180) { // Nhìn Trái
        _item_x = x - 12;
        _item_y = y - 32;
    }
    
    if (action_timer > 0) {
        _item_y += 4; 
    }
}

// Bù trừ origin: đảm bảo sprite luôn được vẽ ở đúng tâm mong muốn
// bất kể origin gốc của sprite đặt ở đâu (0,0 hay giữa)
_item_x += _center_fix_x * abs(_scale_x);
_item_y += _center_fix_y * abs(_scale_y);

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