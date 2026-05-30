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
var _px = x + 12; var _py = y - 10; var _bar_w = 40; var _bar_h = 6;

// ĐÃ SỬA: Ưu tiên cảnh báo "CỎ DẠI" hiển thị lên trên cùng, kể cả khi chưa có cây
if (has_weed == true) {
    draw_set_color(c_black); draw_rectangle(_px, _py, _px + _bar_w, _py + _bar_h, false);
    draw_set_color(c_red); draw_rectangle(_px, _py, _px + _bar_w, _py + _bar_h, false);
    
    draw_set_color(c_red); draw_set_halign(fa_center);
    draw_text_transformed(x + 32, y - 25, "CỎ DẠI!", 0.8, 0.8, 0);
    draw_set_halign(fa_left);
}
else if (plant_stage == 1 || plant_stage == 2) {
    if (is_watered == true && is_infected == false) {
        // Đang phát triển -> Vẽ thanh màu Xanh Lá và đếm ngược Số Giây
        draw_set_color(c_black); draw_rectangle(_px, _py, _px + _bar_w, _py + _bar_h, false);
        var _percent = growth_timer / growth_max;
        draw_set_color(c_lime); draw_rectangle(_px, _py, _px + (_bar_w * _percent), _py + _bar_h, false);
        
        var _sec = ceil((growth_max - growth_timer) / 60);
        draw_set_color(c_white); draw_set_halign(fa_center);
        draw_text_transformed(x + 32, y - 25, string(_sec) + "s", 0.7, 0.7, 0); // Ví dụ: 5s
        draw_set_halign(fa_left);
    }
    else if (is_infected == true) {
        // Bị bệnh -> Vẽ thanh đếm ngược màu Đỏ đến lúc Chết
        draw_set_color(c_black); draw_rectangle(_px, _py, _px + _bar_w, _py + _bar_h, false);
        var _percent = rot_timer / rot_max;
        draw_set_color(c_red); draw_rectangle(_px, _py, _px + (_bar_w * _percent), _py + _bar_h, false);
        
        draw_set_color(c_red); draw_set_halign(fa_center);
        draw_text_transformed(x + 32, y - 25, "BỆNH!", 0.8, 0.8, 0);
        draw_set_halign(fa_left);
    }
    else if (is_watered == false) {
        // Thiếu nước
        draw_set_color(c_aqua); draw_set_halign(fa_center);
        draw_text_transformed(x + 32, y - 25, "Cần Nước", 0.7, 0.7, 0);
        draw_set_halign(fa_left);
    }
}
else if (plant_stage == 3) {
    // Cây đã chín -> Vẽ thanh hẹp màu Đỏ đếm thời gian Hỏng
    var _px2 = x + 12; var _py2 = y - 10; var _bar_w2 = 40; var _bar_h2 = 4;
    draw_set_color(c_black); draw_rectangle(_px2, _py2, _px2 + _bar_w2, _py2 + _bar_h2, false);
    var _percent = rot_timer / rot_max;
    draw_set_color(c_red); draw_rectangle(_px2, _py2, _px2 + (_bar_w2 * _percent), _py2 + _bar_h2, false);
}