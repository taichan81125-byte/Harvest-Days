draw_set_alpha(1.0);
draw_set_color(c_white);

// 1. VẼ ĐẤT VÀ PHÂN BÓN (ÉP KÍCH THƯỚC CHUẨN 64x64 TRÁNH LỖI ẢNH TO)
var _dirt_spr = -1;
if (state == 0) _dirt_spr = spr_dirt_dry;
else if (state == 1) {
    if (is_watered == true) _dirt_spr = spr_dirt_watered;
    else _dirt_spr = spr_dirt_hoed;
}

if (_dirt_spr != -1) {
    draw_sprite_stretched(_dirt_spr, 0, x, y, 64, 64);
}

if (is_fertilized == true && plant_stage == 0) {
    draw_set_color(c_white);
    draw_circle(x + 20, y + 20, 2, false); 
    draw_circle(x + 40, y + 30, 2, false); 
    draw_circle(x + 25, y + 45, 2, false);
}

if (has_weed == true) {
    // Vẽ bụi cỏ dại dính vào ô đất (Vẽ TRƯỚC cây để không che mất cây)
    draw_sprite(spr_weed, 0, x, y);
}

// 2. VẼ CÂY (NẾU CÂY CHẾT SẼ BỊ NHUỘM MÀU XÁM TRO)
if (plant_stage >= 1 && plant_stage <= 4) {
    var _spr = -1;
    var _sprites = [];
    
    if (plant_type == 9) _sprites = [spr_hat_cu_cai_vang, spr_mam_cay, spr_mam_cu_cai_vang, spr_cu_cai_vang];
    else if (plant_type == 10) _sprites = [spr_hat_sup_lo_trang, spr_mam_cay, spr_day_sup_lo_trang, spr_sup_lo_trang];
    else if (plant_type == 11) _sprites = [spr_hat_dau_xanh, spr_mam_cay, spr_day_hat_dau_xanh, spr_dau_xanh];
    else if (plant_type == 12) _sprites = [spr_hat_khoai_tay, spr_mam_cay, spr_mam_khoai_tay, spr_khoai_tay];
    else if (plant_type == 13) _sprites = [spr_hat_viet_quat, spr_mam_cay, spr_cay_viet_quat, spr_viet_quat];
    else if (plant_type == 14) _sprites = [spr_hat_dua_hau, spr_mam_cay, spr_day_dua_hau, spr_dua_hau];
    else if (plant_type == 15) _sprites = [spr_hat_bi_ngo, spr_mam_cay, spr_day_bi_ngo, spr_bi_ngo];
    else if (plant_type == 16) _sprites = [spr_hat_nho, spr_mam_cay, spr_day_nho, spr_nho];
    else if (plant_type == 17) _sprites = [spr_hat_khoai_mo, spr_mam_cay, spr_mam_khoai_mo, spr_khoai_mo];
    
    if (array_length(_sprites) == 4) {
        if (plant_stage == 1) _spr = _sprites[0];
        else if (plant_stage == 2) _spr = _sprites[1];
        else if (plant_stage >= 3) _spr = _sprites[2]; // Giai đoạn trưởng thành hoặc héo
    }
    
    if (_spr != -1) {
        var _sw = max(sprite_get_width(_spr), 1);
        var _sh = max(sprite_get_height(_spr), 1);
        var _max_dim = max(_sw, _sh);
        
        // Đặt kích thước riêng cho từng giai đoạn tránh bị lỗi to nhỏ
        var _target_dim = 52.0; // Kích thước bình thường (Giai đoạn 3, 4)
        if (plant_stage == 1) {
            _target_dim = 24.0; // Hạt giống thì nhỏ gọn
        } else if (plant_stage == 2) {
            _target_dim = 36.0; // Mầm cây vừa phải
        }
        
        var _scale = _target_dim / _max_dim;
        var _draw_w = _sw * _scale;
        var _draw_h = _sh * _scale;
        
        // Tính toán góc trên bên trái để căn giữa trong ô đất 64x64
        var _tl_x = x + (64 - _draw_w) / 2;
        var _tl_y = y + (64 - _draw_h) / 2;
        
        var _col = c_white;
        if (plant_stage == 4) _col = c_gray; // Héo úa
        
        // Dùng stretched_ext để phớt lờ origin gốc, ép vẽ chính xác vào khung đã tính
        draw_sprite_stretched_ext(_spr, 0, _tl_x, _tl_y, _draw_w, _draw_h, _col, 1);
        
        if (plant_stage == 4) {
            draw_set_color(c_ltgray); draw_set_halign(fa_center);
            draw_text_transformed(x + 32, _tl_y - 15, "HÉO CHẾT", 0.7, 0.7, 0);
            draw_set_halign(fa_left);
        }
    }
}

// 3. VẼ SÂU BỆNH
if (is_infected == true && plant_stage != 4) draw_sprite(spr_bug, 0, x + 32, y + 10);

// ========================================================
// 4. VẼ THANH TIẾN ĐỘ THỜI GIAN (UI TRỰC QUAN TRÊN ĐẦU CÂY)
// ========================================================

if (plant_stage >= 1 && plant_stage <= 2) {
    var _px = x + 32; 
    var _py = y - 10;
    
    // Thu bé khung thời gian (ví dụ 64px, tỷ lệ 64/450)
    var _scale = 64 / 450; 
    
    var _bx_left = sprite_get_bbox_left(spr_khung_thoi_gian);
    var _bx_right = sprite_get_bbox_right(spr_khung_thoi_gian);
    var _bx_top = sprite_get_bbox_top(spr_khung_thoi_gian);
    var _bx_bottom = sprite_get_bbox_bottom(spr_khung_thoi_gian);
    
    var _inner_w = (_bx_right - _bx_left) - 8;
    var _inner_h = (_bx_bottom - _bx_top) - 8;
    
    // Tọa độ góc trên cùng bên trái của khung (bất chấp origin của sprite)
    var _tl_x = (x + 32) - (sprite_get_width(spr_khung_thoi_gian) * _scale / 2);
    var _tl_y = y - 24; // Đẩy thanh thời gian lên cao một chút theo yêu cầu
    
    // Tọa độ dùng để vẽ sprite (cộng thêm origin của sprite)
    var _draw_px = _tl_x + (sprite_get_xoffset(spr_khung_thoi_gian) * _scale);
    var _draw_py = _tl_y + (sprite_get_yoffset(spr_khung_thoi_gian) * _scale);
    
    var _bar_x = _tl_x + (_bx_left + 4) * _scale;
    var _bar_y = _tl_y + (_bx_top + 4) * _scale;
    var _bar_w_scaled = _inner_w * _scale;
    var _bar_h_scaled = _inner_h * _scale;
    
    if (is_watered == true && is_infected == false) {
        var _percent = growth_timer / growth_max; 
        if (_percent > 1) _percent = 1;
        
        draw_set_color(c_lime); 
        draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w_scaled * _percent), _bar_y + _bar_h_scaled, false);
        
        draw_sprite_ext(spr_khung_thoi_gian, 0, _draw_px, _draw_py, _scale, _scale, 0, c_white, 1);
    }
    else if (is_infected == true) {
        var _percent = rot_timer / 3600; 
        if (_percent > 1) _percent = 1;
        
        draw_set_color(c_red); 
        draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w_scaled * _percent), _bar_y + _bar_h_scaled, false);
        
        draw_sprite_ext(spr_khung_thoi_gian, 0, _draw_px, _draw_py, _scale, _scale, 0, c_white, 1);
        
        draw_set_color(c_red); draw_set_halign(fa_center);
        draw_text_transformed(x + 32, _tl_y - 15, "BỆNH!", 0.8, 0.8, 0);
        draw_set_halign(fa_left);
    }
    else if (is_watered == false) {
        draw_sprite_ext(spr_khung_thoi_gian, 0, _draw_px, _draw_py, _scale, _scale, 0, c_white, 1);
        
        draw_set_color(c_aqua); draw_set_halign(fa_center);
        draw_text_transformed(x + 32, _tl_y - 15, "Cần Nước", 0.7, 0.7, 0);
        draw_set_halign(fa_left);
    }
}

// Cảnh báo Cỏ dại được vẽ độc lập, không làm mất thanh tiến độ
if (has_weed == true) {
    draw_set_color(c_red); draw_set_halign(fa_center);
    draw_text_transformed(x + 32, y - 35, "CỎ DẠI!", 0.8, 0.8, 0);
    draw_set_halign(fa_left);
}