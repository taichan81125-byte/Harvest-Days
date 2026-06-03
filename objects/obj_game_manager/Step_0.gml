// ==========================================
// CẬP NHẬT ĐỒNG HỒ SINH HỌC & HIỆU ỨNG ÁNH SÁNG
// ==========================================
if (is_paused == false && (room == rm_farm || room == rm_house || room == rm_city)) {
    time_ticker += 1;
    
    if (time_ticker >= frames_per_game_minute) {
        time_ticker = 0;
        game_minute += 1;
        
        if (game_minute >= 60) {
            game_minute = 0;
            game_hour += 1;
            
            // Tự động mọc cỏ dại và sâu bệnh mỗi giờ
            var _weed_count = 0;
            var _infected_count = 0;
            with (obj_dirt) {
                if (state == 1 && has_weed == false && irandom(100) < 2) {
                    has_weed = true;
                    _weed_count++;
                }
                if (plant_stage > 0 && plant_stage < 3 && is_infected == false && irandom(100) < 2) {
                    is_infected = true;
                    _infected_count++;
                }
            }
            if (_weed_count > 0) {
                array_push(night_events, "- Cỏ dại mới mọc quanh ruộng lúc " + string(game_hour) + "h.");
                show_notifications = true;
            }
            if (_infected_count > 0) {
                array_push(night_events, "- Cảnh báo: " + string(_infected_count) + " cây bị sâu bệnh lúc " + string(game_hour) + "h!");
                show_notifications = true;
            }
            
            if (game_hour == 6) {
                night_events = []; // Xóa log báo cáo mỗi sáng
            }
            
            if (game_hour >= 24) {
                game_hour = 0;
            }
        }
    }
    
    // TÍNH TOÁN HIỆU ỨNG ÁNH SÁNG THEO GIỜ
    var _time_decimal = game_hour + (game_minute / 60);
    
    if (_time_decimal >= 6 && _time_decimal < 12) {
        // Buổi sáng: Sáng hoàn toàn
        day_overlay_alpha = 0;
    } 
    else if (_time_decimal >= 12 && _time_decimal < 18) {
        // Buổi chiều: Vàng nhạt tăng dần
        day_overlay_color = c_orange;
        // Từ 12h (alpha 0) đến 18h (alpha 0.15)
        day_overlay_alpha = ((_time_decimal - 12) / 6) * 0.15;
    }
    else if (_time_decimal >= 18 && _time_decimal < 22) {
        // Buổi tối: Cam sang Tím tối dần
        // 18h (alpha 0.15) đến 22h (alpha 0.6)
        var _progress = (_time_decimal - 18) / 4;
        day_overlay_color = merge_color(c_orange, c_navy, _progress);
        day_overlay_alpha = 0.15 + (_progress * 0.45);
    }
    else if (_time_decimal >= 22 || _time_decimal < 2) {
        // Ban đêm: Xanh đậm
        day_overlay_color = c_navy;
        day_overlay_alpha = 0.6;
    }
    else if (_time_decimal >= 2 && _time_decimal < 6) {
        // Bình minh: Sáng dần lên
        day_overlay_color = c_navy;
        // 2h (alpha 0.6) đến 6h (alpha 0)
        day_overlay_alpha = 0.6 - (((_time_decimal - 2) / 4) * 0.6);
    }
}

if (is_raining == true && room != rm_house) {
    if (current_season == 3) {
        effect_create_above(ef_snow, 0, 0, 1, c_white); // Mùa đông: Tuyết
    } else {
        effect_create_above(ef_rain, 0, 0, 1, c_silver); // Mùa khác: Mưa
    }
}

// ==========================================
// KIỂM TRA CHUYỂN MÙA (CROSSFADE)
// ==========================================
if (current_season != prev_season) {
    if (season_transition_active == false) {
        season_transition_active = true;
        season_transition_alpha = 0.0;
    }
}

if (season_transition_active == true) {
    season_transition_alpha += season_transition_speed;
    if (season_transition_alpha >= 1.0) {
        season_transition_alpha = 1.0;
        season_transition_active = false;
        prev_season = current_season;
    }
} else {
    prev_season = current_season;
    season_transition_alpha = 1.0;
}

// ==========================================
// HỆ THỐNG PARTICLE THEO MÙA (TÙY CHỈNH)
// ==========================================
if (room == rm_farm || room == rm_city) {
    // 1. Sinh Particle mới
    var _spawn_chance = 0;
    var _season_effect = -1; // 0=Xuân, 2=Thu, 3=Đông (không mưa)
    
    // Mùa xuân: Hoa đào rơi | Mùa Thu: Lá phong | Mùa Đông: Tuyết (nếu đang mưa)
    if (current_season == 0) { _spawn_chance = 8; _season_effect = 0; }
    else if (current_season == 2) { _spawn_chance = 8; _season_effect = 2; }
    else if (current_season == 3 && is_raining == true) { _spawn_chance = 20; _season_effect = 3; }
    
    particle_spawn_timer += 1;
    if (particle_spawn_timer > 2 && _season_effect != -1 && is_paused == false) {
        particle_spawn_timer = 0;
        if (irandom(100) < _spawn_chance && array_length(season_particles) < max_particles) {
            // Xem viewport hiện tại để sinh particle xung quanh camera
            var _vx = camera_get_view_x(view_camera[0]);
            var _vy = camera_get_view_y(view_camera[0]);
            var _vw = camera_get_view_width(view_camera[0]);
            var _vh = camera_get_view_height(view_camera[0]);
            
            // X sinh rộng hơn khung nhìn một chút
            var _start_x = _vx + irandom_range(-200, _vw + 200);
            var _start_y = _vy - 50; // Luôn rớt từ trên cao xuống
            
            var _p = {
                x: _start_x,
                y: _start_y,
                spd_x: 0,
                spd_y: 0,
                size: random_range(0.5, 1.2),
                alpha: random_range(0.5, 1.0),
                rotation: irandom(360),
                rot_spd: random_range(-2, 2),
                type: _season_effect,
                color: c_white
            };
            
            // Tùy chỉnh thông số theo mùa
            if (_season_effect == 0) { // Xuân (Hoa đào)
                _p.spd_x = random_range(1, 2.5); // Gió thổi chéo
                _p.spd_y = random_range(1.5, 3);
                _p.color = choose(c_fuchsia, c_white, make_color_rgb(255, 182, 193)); // Hồng lạt/trắng
            }
            else if (_season_effect == 2) { // Thu (Lá phong)
                _p.spd_x = random_range(-1.5, 2.5);
                _p.spd_y = random_range(1.5, 3.5);
                _p.rot_spd = random_range(-4, 4);
                _p.color = choose(c_orange, c_red, c_yellow);
                _p.size = random_range(0.8, 1.5);
            }
            else if (_season_effect == 3) { // Đông (Tuyết)
                _p.spd_x = random_range(-0.5, 0.5); // Rơi thẳng
                _p.spd_y = random_range(2, 4.5);
                _p.rot_spd = random_range(-1, 1);
                _p.color = c_white;
                _p.size = random_range(0.3, 0.8);
            }
            
            array_push(season_particles, _p);
        }
    }
    
    // 2. Cập nhật vị trí Particle
    if (is_paused == false) {
        for (var i = array_length(season_particles) - 1; i >= 0; i--) {
            var _p = season_particles[i];
            _p.x += _p.spd_x;
            _p.y += _p.spd_y;
            _p.rotation += _p.rot_spd;
            
            // Nếu xoay vòng lượn sóng nhẹ
            if (_p.type == 0 || _p.type == 2) {
                _p.spd_x += random_range(-0.1, 0.1); 
                _p.spd_x = clamp(_p.spd_x, -2, 3);
            }
            
            // Lấy kích thước camera
            var _vx = camera_get_view_x(view_camera[0]);
            var _vy = camera_get_view_y(view_camera[0]);
            var _vh = camera_get_view_height(view_camera[0]);
            
            // Nếu rơi quá màn hình hoặc ra khỏi room -> Xóa
            if (_p.y > _vy + _vh + 50 || _p.y > room_height || _p.x > room_width || _p.x < 0) {
                array_delete(season_particles, i, 1);
            }
        }
    }
}

// BẤM ESC ĐỂ BẬT/TẮT PAUSE
if (keyboard_check_pressed(vk_escape) && (room == rm_farm || room == rm_house || room == rm_city)) {
    if (show_notifications == true) {
        show_notifications = false;
    }
    else if (is_paused == false) {
        is_paused = true;
        show_shop = false;
        show_dialogue = false;
        show_settings = false;
        show_inventory = false;
    }
    else {
        is_paused = false;
        show_settings = false;
        if (show_inventory == true) {
            show_inventory = false;
            // Nếu đang cầm đồ khi đóng kho bằng ESC, cất lại vào chỗ cũ
            if (drag_item_id != -1) {
                if (drag_src_type == 0) {
                    if (obj_player.inventory[drag_src_index] == -1) {
                        obj_player.inventory[drag_src_index] = drag_item_id;
                        obj_player.inventory_count[drag_src_index] = drag_item_count;
                    } else obj_player.add_item(drag_item_id, drag_item_count);
                } else if (drag_src_type == 1) {
                    if (obj_player.bag[drag_src_index] == -1) {
                        obj_player.bag[drag_src_index] = drag_item_id;
                        obj_player.bag_count[drag_src_index] = drag_item_count;
                    } else obj_player.add_item(drag_item_id, drag_item_count);
                }
                drag_item_id = -1; drag_item_count = 0; drag_src_type = -1; drag_src_index = -1;
            }
        }
    }
}

// CLICK CHUỘT TRÊN GIAO DIỆN
if (mouse_check_button_pressed(mb_left)) {
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// 1. CLICK NÚT X TẮT BẢNG THÔNG BÁO (Ưu tiên cao nhất)
if (show_notifications == true && _mx >= 850 && _mx <= 980 && _my >= 120 && _my <= 220) {
    show_notifications = false;
}
// 2. CLICK NÚT ! Ổ KHÓA (KHI CHƯA MỞ PAUSE)
else if (is_paused == false && _mx >= 1200 && _mx <= 1280 && _my >= 110 && _my <= 180 && (room == rm_farm || room == rm_house || room == rm_city)) {
    show_notifications = !show_notifications;
}
// 3. CLICK ICON BÁNH RĂNG (MỞ PAUSE) - CHỈ Ở TRONG GAME
else if (is_paused == false && _mx > 1200 && _mx < 1260 && _my > 0 && _my < 50 && (room == rm_farm || room == rm_house || room == rm_city)) {
    is_paused = true;
    show_shop = false;
    show_dialogue = false;
    show_settings = false;
    show_inventory = false;
}

// 4. CLICK TRONG MENU TẠM DỪNG (KHI CHƯA MỞ CÀI ĐẶT VÀ CHƯA MỞ KHO ĐỒ)
else if (is_paused == true && show_settings == false && show_inventory == false && show_notifications == false) {
    var _btn_w = 300;
    var _btn_h = 60;
    var _btn_x = 640 - (_btn_w / 2);

    // Nút Tiếp Tục (Y: 250)
    if (_mx >= _btn_x && _mx <= _btn_x + _btn_w && _my >= 250 && _my <= 250 + _btn_h) {
        is_paused = false;
    }
    
    // Nút Cài Đặt (Y: 370) -> Bật bảng Cài Đặt
    if (_mx >= _btn_x && _mx <= _btn_x + _btn_w && _my >= 370 && _my <= 370 + _btn_h) {
        show_settings = true;
    }
    
    // Nút Thoát Về Menu (Y: 490)
    if (_mx >= _btn_x && _mx <= _btn_x + _btn_w && _my >= 490 && _my <= 490 + _btn_h) {
        audio_stop_sound(snd_bgm); // Tắt nhạc khi ra menu
        is_paused = false;
        show_settings = false;
        show_inventory = false;
        room_goto(rm_menu); 
    }
}

// 5. CLICK TRONG BẢNG CÀI ĐẶT ÂM THANH
else if (is_paused == true && show_settings == true) {
    // Nút Giảm Âm Lượng [-]
    if (_mx >= 450 && _mx <= 500 && _my >= 300 && _my <= 350) {
        if (global.is_muted == false && global.master_vol > 0) {
            global.master_vol -= 0.1;
            if (global.master_vol < 0) global.master_vol = 0;
            audio_master_gain(global.master_vol);
        }
    }
    
    // Nút Tăng Âm Lượng [+]
    if (_mx >= 780 && _mx <= 830 && _my >= 300 && _my <= 350) {
        if (global.is_muted == false && global.master_vol < 1.0) {
            global.master_vol += 0.1;
            if (global.master_vol > 1.0) global.master_vol = 1.0;
            audio_master_gain(global.master_vol);
        }
    }
    
    // Nút Tắt/Bật Tiếng
    if (_mx >= 540 && _mx <= 740 && _my >= 400 && _my <= 450) {
        global.is_muted = !global.is_muted; // Đảo ngược trạng thái
        if (global.is_muted == true) {
            audio_master_gain(0); // Tắt tiếng hoàn toàn
        } else {
            audio_master_gain(global.master_vol); // Bật lại theo mức âm lượng hiện tại
        }
    }
    
    // Nút Quay Lại
    if (_mx >= 540 && _mx <= 740 && _my >= 500 && _my <= 550) {
        show_settings = false; // Đóng bảng cài đặt, về lại Menu Pause
    }
}
}


// BẤM TAB ĐỂ BẬT/TẮT KHO ĐỒ
if (keyboard_check_pressed(vk_tab) && (room == rm_farm || room == rm_house || room == rm_city) && show_notifications == false) {
    if (show_inventory == false) {
        show_inventory = true;
        is_paused = true;
        show_shop = false;
        show_dialogue = false;
        show_settings = false;
    } else {
        show_inventory = false;
        is_paused = false;
        // Nếu đang cầm đồ khi đóng kho, cất lại vào chỗ cũ
        if (drag_item_id != -1) {
            if (drag_src_type == 0) {
                if (obj_player.inventory[drag_src_index] == -1) {
                    obj_player.inventory[drag_src_index] = drag_item_id;
                    obj_player.inventory_count[drag_src_index] = drag_item_count;
                } else obj_player.add_item(drag_item_id, drag_item_count);
            } else if (drag_src_type == 1) {
                if (obj_player.bag[drag_src_index] == -1) {
                    obj_player.bag[drag_src_index] = drag_item_id;
                    obj_player.bag_count[drag_src_index] = drag_item_count;
                } else obj_player.add_item(drag_item_id, drag_item_count);
            }
            drag_item_id = -1; drag_item_count = 0; drag_src_type = -1; drag_src_index = -1;
        }
    }
}

if (show_inventory == true) {
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    
    var _start_x = 340;
    var _bag_y1 = 480;
    var _bag_y2 = 550;
    var _hotbar_y = 650;
    
    var _hover_type = -1; // 0: hotbar, 1: bag
    var _hover_index = -1;
    
    // Check if mouse is hovering over any slot
    for(var j=0; j<10; j++) {
        var _sx = _start_x + (j * 60);
        // Check hotbar
        if (_mx >= _sx && _mx <= _sx + 50 && _my >= _hotbar_y && _my <= _hotbar_y + 50) {
            _hover_type = 0; _hover_index = j;
        }
        // Check bag row 1 (index 0-9)
        if (_mx >= _sx && _mx <= _sx + 50 && _my >= _bag_y1 && _my <= _bag_y1 + 50) {
            _hover_type = 1; _hover_index = j;
        }
        // Check bag row 2 (index 10-19)
        if (_mx >= _sx && _mx <= _sx + 50 && _my >= _bag_y2 && _my <= _bag_y2 + 50) {
            _hover_type = 1; _hover_index = j + 10;
        }
    }
    
    if (mouse_check_button_pressed(mb_left)) {
        if (_hover_index != -1 && drag_item_id == -1) {
            // Bắt đầu kéo đồ
            var _id = -1; var _cnt = 0;
            if (_hover_type == 0) {
                _id = obj_player.inventory[_hover_index];
                _cnt = obj_player.inventory_count[_hover_index];
                if (_id != -1) {
                    obj_player.inventory[_hover_index] = -1;
                    obj_player.inventory_count[_hover_index] = 0;
                }
            } else if (_hover_type == 1) {
                _id = obj_player.bag[_hover_index];
                _cnt = obj_player.bag_count[_hover_index];
                if (_id != -1) {
                    obj_player.bag[_hover_index] = -1;
                    obj_player.bag_count[_hover_index] = 0;
                }
            }
            if (_id != -1) {
                drag_item_id = _id; drag_item_count = _cnt;
                drag_src_type = _hover_type; drag_src_index = _hover_index;
            }
        }
    }
    
    if (mouse_check_button_released(mb_left)) {
        if (drag_item_id != -1) {
            if (_hover_index != -1) {
                // Drop vào 1 ô
                var _target_id = -1; var _target_cnt = 0;
                if (_hover_type == 0) {
                    _target_id = obj_player.inventory[_hover_index];
                    _target_cnt = obj_player.inventory_count[_hover_index];
                } else if (_hover_type == 1) {
                    _target_id = obj_player.bag[_hover_index];
                    _target_cnt = obj_player.bag_count[_hover_index];
                }
                
                if (_target_id == drag_item_id) { // Gộp đồ
                    if (_hover_type == 0) obj_player.inventory_count[_hover_index] += drag_item_count;
                    else obj_player.bag_count[_hover_index] += drag_item_count;
                    drag_item_id = -1; drag_item_count = 0; drag_src_type = -1; drag_src_index = -1;
                } else { // Swap đồ
                    if (_hover_type == 0) {
                        obj_player.inventory[_hover_index] = drag_item_id;
                        obj_player.inventory_count[_hover_index] = drag_item_count;
                    } else {
                        obj_player.bag[_hover_index] = drag_item_id;
                        obj_player.bag_count[_hover_index] = drag_item_count;
                    }
                    if (_target_id != -1) {
                        drag_item_id = _target_id; drag_item_count = _target_cnt;
                        drag_src_type = _hover_type; drag_src_index = _hover_index;
                    } else {
                        drag_item_id = -1; drag_item_count = 0; drag_src_type = -1; drag_src_index = -1;
                    }
                }
            } else { // Rơi ra ngoài -> Trả về chỗ cũ
                if (drag_src_type == 0) {
                    if (obj_player.inventory[drag_src_index] == -1) {
                        obj_player.inventory[drag_src_index] = drag_item_id;
                        obj_player.inventory_count[drag_src_index] = drag_item_count;
                    } else obj_player.add_item(drag_item_id, drag_item_count);
                } else if (drag_src_type == 1) {
                    if (obj_player.bag[drag_src_index] == -1) {
                        obj_player.bag[drag_src_index] = drag_item_id;
                        obj_player.bag_count[drag_src_index] = drag_item_count;
                    } else obj_player.add_item(drag_item_id, drag_item_count);
                }
                drag_item_id = -1; drag_item_count = 0; drag_src_type = -1; drag_src_index = -1;
            }
        }
    }
}
