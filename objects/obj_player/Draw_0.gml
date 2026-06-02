// 1. LẤY THÔNG TIN VẬT PHẨM ĐANG CẦM
var _current_item = -1;
if (selected_slot != -1) _current_item = inventory[selected_slot];

// 0. VẼ VIỀN HIGHLIGHT CHỈ ĐỊNH (GRID HIGHLIGHT)
if (obj_game_manager.is_paused == false && _current_item != -1) {
    if (is_action_valid) {
        draw_set_color(c_lime);
        draw_set_alpha(0.3);
    } else {
        draw_set_color(c_red);
        draw_set_alpha(0.3);
    }
    // Vẽ một ô vuông mờ
    draw_rectangle(mouse_tile_x, mouse_tile_y, mouse_tile_x + 63, mouse_tile_y + 63, false);
    
    // Vẽ viền ngoài đậm hơn một chút (dùng 4 hcn để tránh lỗi lệch pixel của outline)
    draw_set_alpha(0.8);
    draw_rectangle(mouse_tile_x, mouse_tile_y, mouse_tile_x + 63, mouse_tile_y + 1, false);
    draw_rectangle(mouse_tile_x, mouse_tile_y + 62, mouse_tile_x + 63, mouse_tile_y + 63, false);
    draw_rectangle(mouse_tile_x, mouse_tile_y, mouse_tile_x + 1, mouse_tile_y + 63, false);
    draw_rectangle(mouse_tile_x + 62, mouse_tile_y, mouse_tile_x + 63, mouse_tile_y + 63, false);
    
    draw_set_color(c_white);
    draw_set_alpha(1.0);
}

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

// ========================================================
// TÙY CHỈNH ĐỘ TO NHỎ CHO TỪNG LOẠI ĐỒ VẬT TỰ ĐỘNG THEO SIZE
// ========================================================
var _max_dim = max(max(_spr_w, _spr_h), 1);
var _base_scale = 1;

if (_current_item >= 18 && _current_item <= 26) {
    // Nông sản
    _base_scale = 16 / _max_dim;
}
else if (_current_item >= 9 && _current_item <= 17) {
    // Hạt giống
    _base_scale = 16 / _max_dim;
}
else if (_current_item >= 6 && _current_item <= 8) {
    // Đồ trang trí
    _base_scale = 22 / _max_dim;
}
else if (_current_item == 4 || _current_item == 5) {
    // Phân bón, Thuốc sinh học
    _base_scale = 16 / _max_dim;
}
else {
    // Công cụ (Cuốc, Bình tưới, Liềm, Xẻng)
    _base_scale = 30 / _max_dim;
}

var _scale_x = _base_scale;
var _scale_y = _base_scale;

// ========================================================
// PHÂN LOẠI: CÔNG CỤ (xoay được) vs ĐỒ VẬT (không xoay)
// ========================================================
var _is_tool = (_current_item == 0 || _current_item == 1 || _current_item == 2 || _current_item == 3);

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

// Bù trừ origin + xoay: đảm bảo TÂM của sprite luôn nằm đúng tại _item_x, _item_y
var _vec_x = ((_spr_w / 2) - _spr_ox) * _scale_x;
var _vec_y = ((_spr_h / 2) - _spr_oy) * _scale_y;
var _dist = point_distance(0, 0, _vec_x, _vec_y);
var _dir = point_direction(0, 0, _vec_x, _vec_y);

_item_x -= lengthdir_x(_dist, _dir + _angle);
_item_y -= lengthdir_y(_dist, _dir + _angle);

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