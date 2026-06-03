// ==========================================
// VẼ HÌNH NỀN NHÀ NÔNG DÂN (KHI Ở TRONG NHÀ)
// ==========================================
if (room == rm_house && variable_global_exists("spr_house_bg") && global.spr_house_bg != -1) {
    draw_sprite_stretched(global.spr_house_bg, 0, 0, 0, room_width, room_height);
}

// ==========================================
// VẼ HÌNH NỀN MAP THEO MÙA (KHI Ở NÔNG TRẠI HOẶC THÀNH PHỐ)
// ==========================================
if (room == rm_farm || room == rm_city) {
    var _sprites_array = (room == rm_farm) ? season_map_sprites : season_city_sprites;
    
    // Vẽ nền cũ nếu đang chuyển mùa
    if (season_transition_active == true) {
        var _spr_old = _sprites_array[prev_season];
        if (_spr_old != -1) {
            draw_sprite_stretched_ext(_spr_old, 0, 0, 0, room_width, room_height, c_white, 1.0);
        }
    }
    
    // Vẽ nền mới
    var _spr_new = _sprites_array[current_season];
    if (_spr_new != -1) {
        draw_sprite_stretched_ext(_spr_new, 0, 0, 0, room_width, room_height, c_white, season_transition_alpha);
    }
    
    // ==========================================
    // VẼ HIỆU ỨNG PARTICLE MÙA
    // ==========================================
    for (var i = 0; i < array_length(season_particles); i++) {
        var _p = season_particles[i];
        
        draw_set_alpha(_p.alpha);
        draw_set_color(_p.color);
        
        // Vẽ hình thoi/chữ nhật xoay mô phỏng chiếc lá hoặc bông tuyết
        if (_p.type == 0 || _p.type == 2) { // Xuân hoặc Thu (Lá/cánh hoa)
            var _len_x1 = lengthdir_x(6 * _p.size, _p.rotation);
            var _len_y1 = lengthdir_y(6 * _p.size, _p.rotation);
            var _len_x2 = lengthdir_x(3 * _p.size, _p.rotation + 90);
            var _len_y2 = lengthdir_y(3 * _p.size, _p.rotation + 90);
            
            draw_primitive_begin(pr_trianglefan);
            draw_vertex(_p.x + _len_x1, _p.y + _len_y1);
            draw_vertex(_p.x + _len_x2, _p.y + _len_y2);
            draw_vertex(_p.x - _len_x1, _p.y - _len_y1);
            draw_vertex(_p.x - _len_x2, _p.y - _len_y2);
            draw_primitive_end();
        } 
        else if (_p.type == 3) { // Đông (Tuyết rơi)
            draw_circle(_p.x, _p.y, 2.5 * _p.size, false);
        }
        
        draw_set_alpha(1.0);
        draw_set_color(c_white);
    }
}
