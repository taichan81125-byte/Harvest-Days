draw_set_font(fnt_vietnamese);

// ==========================================
// HIỆU ỨNG ÁNH SÁNG NGÀY/ĐÊM (VẼ TRƯỚC TIÊN ĐỂ KHÔNG ĐÈ LÊN UI)
// ==========================================
if ((room == rm_farm || room == rm_house || room == rm_city) && day_overlay_alpha > 0) {
    draw_set_color(day_overlay_color);
    draw_set_alpha(day_overlay_alpha);
    // Hardcode kích thước GUI là 1280x720 cho chắc chắn
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
}
if (instance_exists(obj_player) && (room == rm_farm || room == rm_house || room == rm_city)) {
    // Kéo các UI như tim và thức ăn sang phải một chút để sát với Đồng hồ hơn
    var _ui_right_x = 1005; 
    
    for (var i = 0; i < 3; i++) {
        if (i < obj_player.hp) draw_sprite(spr_heart_full, 0, _ui_right_x + (i * 36), 20); 
        else draw_sprite(spr_heart_empty, 0, _ui_right_x + (i * 36), 20); 
    }
    
    var _bar_y = 65;
    draw_set_color(c_dkgray); draw_rectangle(_ui_right_x, _bar_y, _ui_right_x + 100, _bar_y + 15, false); 
    draw_set_color(c_orange); draw_rectangle(_ui_right_x, _bar_y, _ui_right_x + obj_player.hunger, _bar_y + 15, false); 
    draw_set_color(c_white); draw_rectangle(_ui_right_x, _bar_y, _ui_right_x + 100, _bar_y + 15, true); 

    draw_sprite_ext(spr_icon_gear, 0, 1155, -19, 0.33, 0.33, 0, c_white, 1);

    // ==========================================
    // VẼ HUD THỜI GIAN THEO PHONG CÁCH STARDEW VALLEY
    // ==========================================
    var _hud_scale = 0.4; // Thu nhỏ toàn bộ 40% so với trước
    var _hud_w = 339 * _hud_scale;
    var _hud_h = 358 * _hud_scale;
    var _hud_x = 1260 - _hud_w; // Góc trên phải
    var _hud_y = 15;
    
    // 1. Vẽ khung HUD spr_time_day
    draw_sprite_ext(spr_time_day, 0, _hud_x, _hud_y, _hud_scale, _hud_scale, 0, c_white, 1);
    
    // 2. Tính toán Kim đồng hồ (Xoay trên bán nguyệt trái)
    sprite_set_offset(spr_cay_kim, 43, 335); // Đặt lại tâm kim quay vào đáy kim
    var _kim_scale = 0.09; // Thu nhỏ thêm 50% nữa
    var _time_decimal = game_hour + (game_minute / 60);
    if (_time_decimal < 6) _time_decimal += 24; // Tính từ 6 AM sáng
    
    // Xoay 180 độ từ Sáng (Góc dưới trái) đến Tối (Góc trên trái)
    var _angle = 135 - (_time_decimal - 6) * 5; 
    
    // Đẩy tâm quay về đúng đoạn rãnh gờ của khối bán nguyệt
    var _pivot_x = _hud_x + 105 * _hud_scale;
    var _pivot_y = _hud_y + 95 * _hud_scale;
    draw_sprite_ext(spr_cay_kim, 0, _pivot_x, _pivot_y, _kim_scale, _kim_scale, _angle, c_white, 1);
    
    // 3. Text THỨ và NGÀY
    var _day_of_week = (day_count - 1) % 7;
    var _dow_str = "";
    switch(_day_of_week) {
        case 0: _dow_str = "Mon."; break;
        case 1: _dow_str = "Tue."; break;
        case 2: _dow_str = "Wed."; break;
        case 3: _dow_str = "Thu."; break;
        case 4: _dow_str = "Fri."; break;
        case 5: _dow_str = "Sat."; break;
        case 6: _dow_str = "Sun."; break;
    }
    
    var _day_of_season = ((day_count - 1) % 28) + 1;
    
    draw_set_color(c_black); draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text_transformed(_hud_x + 220 * _hud_scale, _hud_y + 45 * _hud_scale, _dow_str + " " + string(_day_of_season), 0.75, 0.75, 0);
    
    // 4. Giờ AM / PM
    var _am_pm = game_hour < 12 ? " am" : " pm";
    var _display_hour = game_hour % 12;
    if (_display_hour == 0) _display_hour = 12;
    var _time_str = string(_display_hour) + ":" + (game_minute < 10 ? "0" : "") + string(game_minute) + _am_pm;
    draw_set_color(make_color_rgb(150, 0, 0)); // Đỏ đậm
    draw_text_transformed(_hud_x + 220 * _hud_scale, _hud_y + 155 * _hud_scale, _time_str, 0.75, 0.75, 0);
    
    // 5. Số Vàng (Mỗi số 1 ô vuông)
    var _gold_str = string(obj_player.coins);
    var _len = string_length(_gold_str);
    if (_len > 8) _gold_str = string_copy(_gold_str, 1, 8);
    var _start_idx = 8 - _len; // Căn phải
    
    draw_set_color(make_color_rgb(100, 20, 20));
    for (var i = 1; i <= _len; i++) {
        var _char = string_char_at(_gold_str, i);
        var _slot_index = _start_idx + i - 1; 
        var _char_x = _hud_x + (85 + _slot_index * 28.5) * _hud_scale;
        var _char_y = _hud_y + 255 * _hud_scale;
        draw_text_transformed(_char_x, _char_y, _char, 0.75, 0.75, 0);
    }
    draw_set_halign(fa_left); draw_set_valign(fa_top);
    
    // 6. Dấu Chấm Than ! (Sử dụng trực tiếp ổ khóa của spr_time_day)
    var _alert_x = _hud_x + 295 * _hud_scale;
    var _alert_y = _hud_y + 320 * _hud_scale;
    
    var _display_events = [];
    for (var _ei = 0; _ei < array_length(night_events); _ei++) {
        array_push(_display_events, night_events[_ei]);
    }
    
    var _weed_cnt = 0; var _bug_cnt = 0; var _wither_cnt = 0;
    if (instance_exists(obj_dirt)) {
        with (obj_dirt) {
            if (has_weed == true) _weed_cnt++;
            if (is_infected == true) _bug_cnt++;
            if (plant_stage == 4) _wither_cnt++;
        }
    }
    
    if (_weed_cnt > 0) array_push(_display_events, "- CHÚ Ý: Đang có " + string(_weed_cnt) + " ô đất bị cỏ dại mọc!");
    if (_bug_cnt > 0) array_push(_display_events, "- CẢNH BÁO: Đang có " + string(_bug_cnt) + " cây bị sâu bệnh cắn phá!");
    if (_wither_cnt > 0) array_push(_display_events, "- ĐÁNG TIẾC: Đã có " + string(_wither_cnt) + " cây chết héo khô!");
    
    var _noti_count = array_length(_display_events);
    if (_noti_count > 0) {
        draw_set_color(c_red); draw_set_alpha(0.5 + sin(current_time/100)*0.5);
        draw_circle(_alert_x, _alert_y, 25 * _hud_scale, false); draw_set_alpha(1.0);
    }
    
    // HUY HIỆU SỐ THÔNG BÁO (Góc trên bên trái ổ khóa)
    var _bx = _alert_x - 1;
    var _by = _alert_y - 8;
    
    // Ô tròn màu đỏ
    draw_set_color(c_red);
    draw_circle(_bx, _by, 5.5, false);
    
    // Viền trắng cho nổi bật
    draw_set_color(c_white);
    draw_circle(_bx, _by, 5.5, true);
    
    // Số màu trắng
    draw_set_color(c_white);
    draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text_transformed(_bx, _by, string(_noti_count), 0.5, 0.5, 0);
    draw_set_halign(fa_left); draw_set_valign(fa_top);

    // 7. Thời tiết và Mùa (Nằm cạnh ổ khóa !)
    var _spr_season = spr_icon_mua_xuan;
    if (current_season == 1) _spr_season = spr_icon_mua_ha;
    if (current_season == 2) _spr_season = spr_icon_mua_thu;
    if (current_season == 3) _spr_season = spr_icon_mua_dong;
    var _spr_weather = is_raining ? spr_icon_troi_mua : spr_icon_troi_nang;
    
    var _icon_scale = 0.35; // Thu bé đi 30%
    draw_sprite_ext(_spr_weather, 0, _alert_x - 90, _alert_y - 10, _icon_scale, _icon_scale, 0, c_white, 1);
    draw_sprite_ext(_spr_season, 0, _alert_x - 60, _alert_y - 10, _icon_scale, _icon_scale, 0, c_white, 1);
    var _start_x = 340; var _y = 650;       
    
    for(var j = 0; j < 10; j++) {
        var _slot_x = _start_x + (j * 60);
        
        // Vẽ viền sáng khi đang chọn
        if (obj_player.selected_slot == j) { draw_set_color(c_yellow); draw_rectangle(_slot_x - 3, _y - 3, _slot_x + 53, _y + 53, false); }
        
        // Nền ô mờ ảo bóng bẩy
        draw_set_color(c_black); draw_set_alpha(0.6);
        draw_rectangle(_slot_x, _y, _slot_x + 50, _y + 50, false);
        draw_set_alpha(1.0);
        
        // Viền ô màu kim loại
        draw_set_color(c_silver); draw_rectangle(_slot_x, _y, _slot_x + 50, _y + 50, true);
        
        var _item_id = obj_player.inventory[j];
        if (_item_id != -1) {
            var _spr = item_sprites[_item_id];
            draw_sprite_stretched(_spr, 0, _slot_x + 5, _y + 5, 40, 40);
            
            var _count = obj_player.inventory_count[j];
            if (_count > 1) {
                draw_set_color(c_black); draw_set_halign(fa_right); draw_text(_slot_x + 49, _y + 31, string(_count)); // Bóng đổ cho số lượng
                draw_set_color(c_white); draw_text(_slot_x + 48, _y + 30, string(_count)); draw_set_halign(fa_left);
            }
        }
        
        // Số 1-10 ở dưới
        draw_set_color(c_black); 
        if (j == 9) draw_text(_slot_x + 6, _y - 24, "0"); else draw_text(_slot_x + 6, _y - 24, string(j + 1));
        draw_set_color(c_yellow); 
        if (j == 9) draw_text(_slot_x + 5, _y - 25, "0"); else draw_text(_slot_x + 5, _y - 25, string(j + 1));
    }
    
    if (obj_player.item_popup_timer > 0 && obj_player.selected_slot != -1) {
        var _current_item = obj_player.inventory[obj_player.selected_slot];
        if (_current_item != -1) {
            var _item_name = item_names[_current_item]; var _alpha = 1.0;
            if (obj_player.item_popup_timer < 30) _alpha = obj_player.item_popup_timer / 30;
            draw_set_alpha(_alpha); draw_set_halign(fa_center); draw_set_color(c_white); draw_text(640, 590, _item_name); draw_set_halign(fa_left); draw_set_alpha(1.0);
        }
    }
} 

    // ==========================================
    // VẼ MINIMAP (BẢN ĐỒ THU NHỎ) - CHỈ Ở FARM & CITY
    // ==========================================
    if (room == rm_farm || room == rm_city) {
        var _mm_x = 20;
        var _mm_y = 15; // Đẩy minimap lên trên cùng
        var _mm_w = 200;
        var _mm_h = 150;
        
        // 1. Xác định map cần vẽ
        var _map_spr = -1;
        if (room == rm_farm) {
            _map_spr = season_map_sprites[current_season];
        } else if (room == rm_city) {
            // Kiểm tra xem mảng city có được khởi tạo chưa (đề phòng lỗi)
            if (variable_instance_exists(id, "season_city_sprites")) {
                _map_spr = season_city_sprites[current_season];
            }
        }
        
        // 2. Vẽ hình nền bản đồ
        if (_map_spr != -1) {
            draw_sprite_stretched(_map_spr, 0, _mm_x, _mm_y, _mm_w, _mm_h);
        } else {
            draw_set_color(c_black); draw_set_alpha(0.5);
            draw_rectangle(_mm_x, _mm_y, _mm_x + _mm_w, _mm_y + _mm_h, false); draw_set_alpha(1.0);
        }
        
        // 3. Vẽ viền bản đồ thu nhỏ
        draw_set_color(c_white);
        draw_rectangle(_mm_x, _mm_y, _mm_x + _mm_w, _mm_y + _mm_h, true);
        
        // 4. Vẽ khung camera hiện tại
        var _cam = view_camera[0];
        var _cam_x = camera_get_view_x(_cam);
        var _cam_y = camera_get_view_y(_cam);
        var _cam_w = camera_get_view_width(_cam);
        var _cam_h = camera_get_view_height(_cam);
        
        // Tỉ lệ (scale)
        var _rw = room_width;
        var _rh = room_height;
        if (_rw == 0) _rw = 4000;
        if (_rh == 0) _rh = 3000;
        var _sx = _mm_w / _rw;
        var _sy = _mm_h / _rh;
        
        var _rect_x = _mm_x + (_cam_x * _sx);
        var _rect_y = _mm_y + (_cam_y * _sy);
        var _rect_w = _cam_w * _sx;
        var _rect_h = _cam_h * _sy;
        
        // Vẽ khung nhìn (khung màu vàng)
        draw_set_color(c_yellow);
        draw_rectangle(_rect_x, _rect_y, _rect_x + _rect_w, _rect_y + _rect_h, true);
        
        // Vẽ vị trí người chơi (chấm nhỏ màu đỏ)
        var _px = _mm_x + (obj_player.x * _sx);
        var _py = _mm_y + (obj_player.y * _sy);
        draw_set_color(c_red);
        draw_circle(_px, _py, 3, false);
    }

// =========================================================
// MỤC MỚI: VẼ MENU TẠM DỪNG VÀ CÀI ĐẶT
// =========================================================
if (is_paused == true) {
draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(0, 0, 1280, 720, false); draw_set_alpha(1.0);
draw_set_halign(fa_center);

// NẾU ĐANG Ở MENU PAUSE THƯỜNG
if (show_settings == false && show_inventory == false) {
    draw_set_color(c_yellow); draw_text_transformed(640, 100, "TẠM DỪNG", 2, 2, 0);
    var _btn_w = 300; var _btn_h = 60; var _btn_x = 640 - (_btn_w / 2);
    var _btn_texts = ["Tiếp Tục", "Cài Đặt", "Thoát Về Menu"];
    
    for(var i = 0; i < 3; i++) {
        var _btn_y = 250 + (i * 120);
        draw_set_color(c_dkgray); draw_rectangle(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, false);
        draw_set_color(c_white); draw_rectangle(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, true);
        draw_text(_btn_x + (_btn_w / 2), _btn_y + 15, _btn_texts[i]);
    }
}
// NẾU ĐANG BẬT BẢNG CÀI ĐẶT
else if (show_settings == true) {
    draw_set_color(c_yellow); draw_text_transformed(640, 100, "CÀI ĐẶT ÂM THANH", 2, 2, 0);
    
    // Vẽ chữ hiển thị % âm lượng
    draw_set_color(c_white);
    var _vol_percent = floor(global.master_vol * 100);
    if (global.is_muted == true) draw_text_transformed(640, 220, "Âm lượng: TẮT", 1.5, 1.5, 0);
    else draw_text_transformed(640, 220, "Âm lượng: " + string(_vol_percent) + "%", 1.5, 1.5, 0);
    
    // Vẽ nút [-]
    draw_set_color(c_dkgray); draw_rectangle(450, 300, 500, 350, false);
    draw_set_color(c_white); draw_rectangle(450, 300, 500, 350, true); draw_text(475, 310, "-");
    
    // Vẽ thanh mô phỏng âm lượng ở giữa
    draw_rectangle(520, 310, 760, 340, true);
    draw_set_color(c_lime); draw_rectangle(522, 312, 522 + (236 * global.master_vol), 338, false);
    
    // Vẽ nút [+]
    draw_set_color(c_dkgray); draw_rectangle(780, 300, 830, 350, false);
    draw_set_color(c_white); draw_rectangle(780, 300, 830, 350, true); draw_text(805, 310, "+");
    
    // Vẽ nút TẮT/BẬT TIẾNG
    var _mute_text = (global.is_muted == true) ? "Bật Tiếng" : "Tắt Tiếng";
    draw_set_color(c_dkgray); draw_rectangle(540, 400, 740, 450, false);
    draw_set_color(c_white); draw_rectangle(540, 400, 740, 450, true); draw_text(640, 410, _mute_text);
    
    // Vẽ nút TRỞ VỀ
    draw_set_color(c_dkgray); draw_rectangle(540, 500, 740, 550, false);
    draw_set_color(c_red); draw_rectangle(540, 500, 740, 550, true); draw_text(640, 510, "Trở Về");
}
// NẾU ĐANG MỞ KHO ĐỒ
else if (show_inventory == true) {
    // Vẽ Tiêu đề có bóng đổ
    draw_set_color(c_black); draw_text_transformed(642, 102, "KHO ĐỒ CÁ NHÂN", 2, 2, 0);
    draw_set_color(c_yellow); draw_text_transformed(640, 100, "KHO ĐỒ CÁ NHÂN", 2, 2, 0);
    draw_set_halign(fa_left);
    
    var _start_x = 340;
    
    // Panel kính mờ ảo phía sau UI Inventory
    draw_set_color(c_white); draw_set_alpha(0.08);
    draw_roundrect(_start_x - 20, 460, _start_x + (10 * 60) + 10, 715, false);
    draw_set_color(c_yellow); draw_set_alpha(0.2);
    draw_roundrect(_start_x - 20, 460, _start_x + (10 * 60) + 10, 715, true);
    draw_set_alpha(1.0);
    
    // VẼ KHO ĐỒ 20 Ô (2 HÀNG)
    for (var i = 0; i < 2; i++) {
        var _y = (i == 0) ? 480 : 550;
        for (var j = 0; j < 10; j++) {
            var _slot_index = (i * 10) + j;
            var _slot_x = _start_x + (j * 60);
            
            draw_set_color(c_black); draw_set_alpha(0.6);
            draw_rectangle(_slot_x, _y, _slot_x + 50, _y + 50, false);
            draw_set_alpha(1.0);
            draw_set_color(c_silver); draw_rectangle(_slot_x, _y, _slot_x + 50, _y + 50, true);
            
            var _item_id = obj_player.bag[_slot_index];
            if (_item_id != -1) {
                var _spr = item_sprites[_item_id];
                draw_sprite_stretched(_spr, 0, _slot_x + 5, _y + 5, 40, 40);
                var _count = obj_player.bag_count[_slot_index];
                if (_count > 1) {
                    draw_set_color(c_black); draw_set_halign(fa_right); draw_text(_slot_x + 49, _y + 31, string(_count));
                    draw_set_color(c_white); draw_text(_slot_x + 48, _y + 30, string(_count)); draw_set_halign(fa_left);
                }
            }
        }
    }
    
    // VẼ HOTBAR (DÙ NÓ ĐƯỢC VẼ Ở TRÊN NHƯNG KHI MỞ INVENTORY CẦN VẼ LẠI ĐỂ KHÔNG BỊ LỚP MỜ ĐÈ LÊN)
    var _hy = 650;
    for (var j = 0; j < 10; j++) {
        var _slot_x = _start_x + (j * 60);
        if (obj_player.selected_slot == j) { draw_set_color(c_yellow); draw_rectangle(_slot_x - 3, _hy - 3, _slot_x + 53, _hy + 53, false); }
        
        draw_set_color(c_black); draw_set_alpha(0.6);
        draw_rectangle(_slot_x, _hy, _slot_x + 50, _hy + 50, false);
        draw_set_alpha(1.0);
        draw_set_color(c_silver); draw_rectangle(_slot_x, _hy, _slot_x + 50, _hy + 50, true);
        
        var _item_id = obj_player.inventory[j];
        if (_item_id != -1) {
            var _spr = item_sprites[_item_id];
            draw_sprite_stretched(_spr, 0, _slot_x + 5, _hy + 5, 40, 40);
            var _count = obj_player.inventory_count[j];
            if (_count > 1) {
                draw_set_color(c_black); draw_set_halign(fa_right); draw_text(_slot_x + 49, _hy + 31, string(_count));
                draw_set_color(c_white); draw_text(_slot_x + 48, _hy + 30, string(_count)); draw_set_halign(fa_left);
            }
        }
        
        draw_set_color(c_black); 
        if (j == 9) draw_text(_slot_x + 6, _hy - 24, "0"); else draw_text(_slot_x + 6, _hy - 24, string(j + 1));
        draw_set_color(c_yellow); 
        if (j == 9) draw_text(_slot_x + 5, _hy - 25, "0"); else draw_text(_slot_x + 5, _hy - 25, string(j + 1));
    }
    
    // VẼ VẬT PHẨM ĐANG BỊ KÉO DÍNH CHUỘT
    if (drag_item_id != -1) {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _spr = item_sprites[drag_item_id];
        
        // Vẽ bóng đổ cho item đang kéo
        draw_sprite_stretched_ext(_spr, 0, _mx - 15, _my - 15, 40, 40, c_black, 0.5);
        draw_sprite_stretched(_spr, 0, _mx - 20, _my - 20, 40, 40);
        
        if (drag_item_count > 1) {
            draw_set_color(c_black); draw_set_halign(fa_right); draw_text(_mx + 19, _my + 6, string(drag_item_count));
            draw_set_color(c_white); draw_text(_mx + 18, _my + 5, string(drag_item_count)); draw_set_halign(fa_left);
        }
    }
}
draw_set_halign(fa_left); 


}

// CÁC UI CŨ BÊN DƯỚI GIỮ NGUYÊN (Hộp thoại, Cửa hàng...)
if (show_dialogue == true && is_paused == false) {
draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(50, 500, 1230, 680, false);
draw_set_alpha(1.0); draw_set_color(c_white); draw_rectangle(50, 500, 1230, 680, true);
draw_text_ext(70, 520, dialogue_text, 30, 1100);
draw_set_color(c_yellow); draw_text(1000, 640, "[Nhấn SPACE để đóng]");
}

if (show_shop == true && is_paused == false) {
draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(200, 100, 1080, 600, false);
draw_set_alpha(1.0); draw_set_color(c_white); draw_rectangle(200, 100, 1080, 600, true);
draw_text(450, 130, "--- CỬA HÀNG HÔM NAY ---");

var _start_x = 250; var _btn_y = 250;
for(var i = 0; i < 5; i++) {
    var _item_id = daily_shop[i];
    var _btn_x = _start_x + (i * 150); 
    
    draw_set_color(c_dkgray); draw_rectangle(_btn_x, _btn_y, _btn_x + 100, _btn_y + 100, false);
    draw_set_color(c_white); draw_rectangle(_btn_x, _btn_y, _btn_x + 100, _btn_y + 100, true);
    
    if (_item_id != -1) {
        var _price = item_prices[_item_id]; var _spr = item_sprites[_item_id]; 
        draw_sprite_stretched(_spr, 0, _btn_x + 18, _btn_y + 18, 64, 64);
        if (_item_id == 2 || _item_id == 3) {
            draw_set_color(c_yellow); draw_set_halign(fa_right); draw_text(_btn_x + 95, _btn_y + 75, "x5"); draw_set_halign(fa_left); draw_set_color(c_white);
        }
        draw_text(_btn_x + 10, _btn_y + 110, string(_price) + " Vàng");
    } else {
        draw_set_color(c_gray); draw_text(_btn_x + 15, _btn_y + 40, "Đã Bán"); draw_set_color(c_white);
    }
}
draw_set_color(c_yellow); draw_text(450, 550, "[Nhấn SPACE để đóng]");


}

// VẼ BẢNG THÔNG BÁO OVERNIGHT
if (show_notifications == true) {
    // Overlay xám
    draw_set_color(c_black); draw_set_alpha(0.6);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
    
    // Khung gỗ hiển thị tin
    var _bx = 340, _by = 150, _bw = 600, _bh = 400;
    draw_set_color(make_color_rgb(139, 69, 19)); // SaddleBrown
    draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
    draw_set_color(make_color_rgb(205, 133, 63)); // Peru
    draw_rectangle(_bx + 5, _by + 5, _bx + _bw - 5, _by + _bh - 5, false);
    
    draw_set_color(c_white); draw_set_halign(fa_center);
    draw_text(_bx + _bw/2, _by + 20, "THÔNG BÁO");
    draw_set_halign(fa_left);
    
    if (array_length(_display_events) == 0) {
        draw_text(_bx + 30, _by + 80, "Không có sự kiện gì đặc biệt xảy ra.");
    } else {
        for (var k = 0; k < array_length(_display_events); k++) {
            draw_text(_bx + 30, _by + 80 + (k * 40), _display_events[k]);
        }
    }
    
    // Nút X để đóng
    draw_set_color(c_red);
    draw_rectangle(_bx + _bw - 40, _by + 10, _bx + _bw - 10, _by + 40, false);
    draw_set_color(c_white); draw_set_halign(fa_center); draw_set_valign(fa_middle);
    draw_text(_bx + _bw - 25, _by + 25, "X");
    draw_set_halign(fa_left); draw_set_valign(fa_top);
}

// VẼ CON TRỎ CHUỘT CUSTOM (To hơn 30%)
if (room != rm_menu && room != rm_load_game) {
    draw_sprite_ext(spr_mouse, 0, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 1.3, 1.3, 0, c_white, 1);
}