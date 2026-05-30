// 1. VẼ ĐẤT VÀ PHÂN BÓN
if (state == 0) draw_sprite(spr_dirt_dry, 0, x, y);
else if (state == 1) {
    if (is_watered == true) draw_sprite(spr_dirt_watered, 0, x, y);
    else draw_sprite(spr_dirt_hoed, 0, x, y);
}

if (is_fertilized == true && plant_stage == 0) {
    draw_set_color(c_white);
    draw_circle(x + 20, y + 20, 2, false); 
    draw_circle(x + 40, y + 30, 2, false); 
    draw_circle(x + 25, y + 45, 2, false);
}

// 2. VẼ CÂY (NẾU CÂY CHẾT SẼ BỊ NHUỘM MÀU XÁM TRO)
if (plant_stage == 1) draw_sprite(spr_seed, 0, x, y);
else if (plant_stage == 2) draw_sprite(spr_plant_sprout, 0, x, y);
else if (plant_stage == 3) {
    draw_sprite(spr_plant_mature, 0, x, y); 
}
else if (plant_stage == 4) {
    // Dùng ảnh mầm cây nhuộm màu Xám Tro để thể hiện sự héo úa
    draw_sprite_ext(spr_plant_sprout, 0, x, y, 1, 1, 0, c_gray, 1);
}

// 3. VẼ SÂU BỆNH VÀ CỎ DẠI
if (is_infected == true && plant_stage != 4) draw_sprite(spr_bug, 0, x + 32, y + 10);

if (has_weed == true) {
    // Vẽ bụi cỏ dại mọc đè lên ô đất
    draw_sprite(spr_weed, 0, x, y);
}

// ========================================================
// 4. VẼ THANH TIẾN ĐỘ THỜI GIAN (UI TRỰC QUAN TRÊN ĐẦU CÂY)
// ========================================================

if (plant_stage == 1 || plant_stage == 2) {
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
    
    // Tọa độ đặt khung sao cho căn giữa gốc cây
    _px = (x + 32) - (sprite_get_width(spr_khung_thoi_gian) * _scale / 2);
    _py = y - 30; // Đẩy thanh thời gian lên cao một chút theo yêu cầu
    
    var _bar_x = _px + (_bx_left + 4) * _scale;
    var _bar_y = _py + (_bx_top + 4) * _scale;
    var _bar_w_scaled = _inner_w * _scale;
    var _bar_h_scaled = _inner_h * _scale;
    
    if (is_watered == true && is_infected == false) {
        var _percent = growth_timer / 7200; 
        if (_percent > 1) _percent = 1;
        
        draw_set_color(c_lime); 
        draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w_scaled * _percent), _bar_y + _bar_h_scaled, false);
        
        draw_sprite_ext(spr_khung_thoi_gian, 0, _px, _py, _scale, _scale, 0, c_white, 1);
    }
    else if (is_infected == true) {
        var _percent = rot_timer / 3600; 
        if (_percent > 1) _percent = 1;
        
        draw_set_color(c_red); 
        draw_rectangle(_bar_x, _bar_y, _bar_x + (_bar_w_scaled * _percent), _bar_y + _bar_h_scaled, false);
        
        draw_sprite_ext(spr_khung_thoi_gian, 0, _px, _py, _scale, _scale, 0, c_white, 1);
        
        draw_set_color(c_red); draw_set_halign(fa_center);
        draw_text_transformed(x + 32, _py - 15, "BỆNH!", 0.8, 0.8, 0);
        draw_set_halign(fa_left);
    }
    else if (is_watered == false) {
        draw_sprite_ext(spr_khung_thoi_gian, 0, _px, _py, _scale, _scale, 0, c_white, 1);
        
        draw_set_color(c_aqua); draw_set_halign(fa_center);
        draw_text_transformed(x + 32, _py - 15, "Cần Nước", 0.7, 0.7, 0);
        draw_set_halign(fa_left);
    }
}

// Cảnh báo Cỏ dại được vẽ độc lập, không làm mất thanh tiến độ
if (has_weed == true) {
    draw_set_color(c_red); draw_set_halign(fa_center);
    draw_text_transformed(x + 32, y - 35, "CỎ DẠI!", 0.8, 0.8, 0);
    draw_set_halign(fa_left);
}