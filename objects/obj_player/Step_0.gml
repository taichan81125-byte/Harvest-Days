// THÊM BIẾN is_paused ĐỂ KHÓA DI CHUYỂN VÀ HOTBAR KHI PAUSE
var _is_ui_open = (obj_game_manager.show_dialogue == true || obj_game_manager.show_shop == true || obj_game_manager.is_paused == true);

if (_is_ui_open == false) {

    // ==========================================
    // HỆ THỐNG SINH TỒN (TRỪ ĐÓI, MẤT MÁU, NGẤT XỈU)
    // ==========================================
    // 1. Trừ thức ăn theo thời gian (Trừ rất chậm)
    hunger -= 0.01; 
    if (hunger < 0) hunger = 0;

    // 2. Chậm lại nếu quá đói
    if (hunger < 30) move_speed = base_speed / 2; // Đi chậm một nửa
    else move_speed = base_speed; // Bình thường

    // 3. Trừ máu (hp) nếu thức ăn bằng 0
    if (hunger == 0) {
        hp_timer += 1;
        if (hp_timer >= 120) { // Mỗi 2 giây trừ 1 máu
            hp -= 1;
            hp_timer = 0;
            effect_create_above(ef_smoke, x, y, 1, c_red);
        }
    } else {
        hp_timer = 0; // Hồi phục bộ đếm nếu có ăn
    }

    // 4. NGẤT XỈU KHI HẾT MÁU (hp <= 0)
    if (hp <= 0) {
        // Đưa về giường ngủ
        x = obj_bed.x; 
        y = obj_bed.y;
        
        // Trừ 10 vàng viện phí, hồi lại 50 thức ăn, 3 máu
        coins -= 10; 
        if (coins < 0) coins = 0;
        hunger = 50; 
        hp = 3;
        
        // Qua ngày mới luôn
        obj_game_manager.reset_shop(); 
        obj_game_manager.day_count += 1; // CẬP NHẬT NGÀY MỚI
        
        // Tạo thời tiết ngẫu nhiên cho ngày hôm sau
        var _rain_chance = irandom(99); 
        if (_rain_chance < 30) obj_game_manager.is_raining = true; else obj_game_manager.is_raining = false;

        with (obj_dirt) {
            // Thời gian thực lo việc cây lớn, đi ngủ chỉ tính thời tiết và sâu bọ
            if (obj_game_manager.is_raining == true) is_watered = true; else is_watered = false; 
            
            // TỈ LỆ 20% SINH SÂU BỆNH QUA ĐÊM 
            if (plant_stage > 0 && plant_stage < 4) {
                if (irandom(100) < 20) {
                    is_infected = true;
                }
            }
            
            // TỈ LỆ 15% MỌC CỎ DẠI QUA ĐÊM (Áp dụng cho đất đã cuốc)
            if (state == 1 && has_weed == false) {
                if (irandom(100) < 15) {
                    has_weed = true;
                }
            }
        }
        
        // --- TỰ ĐỘNG LƯU GAME SAU KHI NGẤT XỈU VÀO ĐÚNG SLOT ĐANG CHƠI ---
        obj_game_manager.save_game(global.current_save_file, global.player_name);
        
        show_debug_message("BẠN ĐÃ NGẤT XỈU! Bị trừ 10 Vàng viện phí và mất một ngày.");
    }

    // ==========================================
    // TÍNH NĂNG ĂN UỐNG (PHÍM E)
    // ==========================================
    if (keyboard_check_pressed(ord("E"))) {
        var _current_item = inventory[selected_slot];
        if (_current_item == 7 || _current_item == 11) { // Ăn Cà Chua Thường hoặc Hạng A
            if (hunger < 100 || hp < 3) {
                var _hunger_heal = (_current_item == 11) ? 50 : 30; // Hạng A hồi 50 đói, thường hồi 30
                var _hp_heal = (_current_item == 11) ? 2 : 1;       // Hạng A hồi 2 máu, thường hồi 1
                
                hunger += _hunger_heal; 
                if (hunger > 100) hunger = 100;
                hp += _hp_heal;  
                if (hp > 3) hp = 3;
                
                // Trừ cà chua trong túi
                inventory_count[selected_slot] -= 1;
                if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1;
                
                // PHÁT ÂM THANH ĂN UỐNG
                audio_play_sound(snd_eat, 1, false);
                effect_create_above(ef_star, x, y + 10, 1, c_lime);
                show_debug_message("Đã ăn Cà Chua! Hồi máu và thức ăn.");
            } else {
                show_debug_message("Bạn đang no, không cần ăn thêm!");
            }
        }
    }

    // ==========================================
    // CHỌN CÔNG CỤ & POPUP
    // ==========================================
    var _slot_changed = false;
    if (keyboard_check_pressed(ord("1"))) { selected_slot = 0; _slot_changed = true; }
    if (keyboard_check_pressed(ord("2"))) { selected_slot = 1; _slot_changed = true; }
    if (keyboard_check_pressed(ord("3"))) { selected_slot = 2; _slot_changed = true; }
    if (keyboard_check_pressed(ord("4"))) { selected_slot = 3; _slot_changed = true; }
    if (keyboard_check_pressed(ord("5"))) { selected_slot = 4; _slot_changed = true; }
    if (keyboard_check_pressed(ord("6"))) { selected_slot = 5; _slot_changed = true; }
    if (keyboard_check_pressed(ord("7"))) { selected_slot = 6; _slot_changed = true; }
    if (keyboard_check_pressed(ord("8"))) { selected_slot = 7; _slot_changed = true; }
    if (keyboard_check_pressed(ord("9"))) { selected_slot = 8; _slot_changed = true; }
    if (keyboard_check_pressed(ord("0"))) { selected_slot = 9; _slot_changed = true; }

    if (_slot_changed == true) item_popup_timer = 90;
    if (item_popup_timer > 0) item_popup_timer -= 1;

    // Giảm thời gian hoạt ảnh vung công cụ
    if (action_timer > 0) action_timer -= 1;

    // ==========================================
    // DI CHUYỂN VÀ VA CHẠM
    // ==========================================
    var _right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    var _left = keyboard_check(vk_left) || keyboard_check(ord("A"));
    var _down = keyboard_check(vk_down) || keyboard_check(ord("S"));
    var _up = keyboard_check(vk_up) || keyboard_check(ord("W"));

    var _hspd = (_right - _left) * move_speed;
    var _vspd = (_down - _up) * move_speed;

    if (_right) facing_dir = 0;
    if (_up) facing_dir = 90;
    if (_left) facing_dir = 180;
    if (_down) facing_dir = 270;

    // CẬP NHẬT HOẠT ẢNH (1 SPRITE - 16 KHUNG HÌNH)
    image_speed = 0; 
    var _base_frame = 0;

    if (facing_dir == 90)  _base_frame = 0;   
    if (facing_dir == 270) _base_frame = 4;   
    if (facing_dir == 0)   _base_frame = 8;   
    if (facing_dir == 180) _base_frame = 12;  

    if (_hspd != 0 || _vspd != 0) {
        local_frame += 0.15; 
        if (local_frame >= 4) { local_frame -= 4; } 
        image_index = _base_frame + floor(local_frame);
    } 
    else {
        local_frame = 0;
        image_index = _base_frame; 
    }

    if (place_meeting(x + _hspd, y, obj_solid)) {
        while (!place_meeting(x + sign(_hspd), y, obj_solid)) x += sign(_hspd);
        _hspd = 0; 
    }
    x += _hspd;

    if (place_meeting(x, y + _vspd, obj_solid)) {
        while (!place_meeting(x, y + sign(_vspd), obj_solid)) y += sign(_vspd);
        _vspd = 0; 
    }
    y += _vspd;

}

// ==========================================
// THAO TÁC CỬA HÀNG
// ==========================================
// THÊM BIẾN KIỂM TRA ĐỂ KHÔNG CLICK MUA HÀNG KHI ĐANG PAUSE
if (obj_game_manager.show_shop == true && obj_game_manager.is_paused == false) {
    if (mouse_check_button_pressed(mb_left)) {
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);

        for(var i = 0; i < 5; i++) {
            var _btn_x = 250 + (i * 150);
            var _btn_y = 250;
            
            if (_mx >= _btn_x && _mx <= _btn_x + 100 && _my >= _btn_y && _my <= _btn_y + 100) {
                var _item_id = obj_game_manager.daily_shop[i];
                
                if (_item_id != -1) { 
                    var _price = obj_game_manager.item_prices[_item_id];
                    var _buy_count = 1;
                    if (_item_id == 2 || _item_id == 3) _buy_count = 5; 
                    
                    if (coins >= _price) {
                        var _found_slot = -1;
                        var _empty_slot = -1;
                        
                        for(var k = 0; k < 10; k++) {
                            if (inventory[k] == _item_id) { _found_slot = k; break; }
                            if (inventory[k] == -1 && _empty_slot == -1) { _empty_slot = k; }
                        }
                        
                        if (_found_slot != -1) {
                            coins -= _price;
                            inventory_count[_found_slot] += _buy_count; 
                            obj_game_manager.daily_shop[i] = -1; 
                            audio_play_sound(snd_coin, 1, false); // PHÁT ÂM THANH MUA HÀNG
                        } else if (_empty_slot != -1) {
                            coins -= _price;
                            inventory[_empty_slot] = _item_id;
                            inventory_count[_empty_slot] = _buy_count; 
                            obj_game_manager.daily_shop[i] = -1; 
                            audio_play_sound(snd_coin, 1, false); // PHÁT ÂM THANH MUA HÀNG
                        }
                    }
                }
            }
        }
    }
    if (keyboard_check_pressed(vk_space)) obj_game_manager.show_shop = false;
}

// ==========================================
// TƯƠNG TÁC SPACE VỚI MÔI TRƯỜNG
// ==========================================
// THÊM BIẾN KIỂM TRA ĐỂ KHÔNG TƯƠNG TÁC KHI ĐANG PAUSE
else if (keyboard_check_pressed(vk_space) && obj_game_manager.is_paused == false) {
    if (obj_game_manager.show_dialogue == true) {
        obj_game_manager.show_dialogue = false;
    }
    else {
        var _interact_x = x + lengthdir_x(48, facing_dir);
        var _interact_y = (y - 32) + lengthdir_y(48, facing_dir);

        var _target_bed = collision_circle(_interact_x, _interact_y, 32, obj_bed, false, true);
        var _target_dirt = collision_circle(_interact_x, _interact_y, 32, obj_dirt, false, true);
        var _target_bin = collision_circle(_interact_x, _interact_y, 32, obj_bin, false, true);
        var _target_npc = collision_circle(_interact_x, _interact_y, 32, obj_npc_moc, false, true);
        var _target_shop = collision_circle(_interact_x, _interact_y, 32, obj_shop, false, true);
        var _target_table = collision_circle(_interact_x, _interact_y, 32, obj_table, false, true);
        var _target_deco = collision_circle(_interact_x, _interact_y, 32, obj_decoration, false, true);
        var _target_solid = collision_circle(_interact_x, _interact_y, 32, obj_solid, false, true);
        
        var _current_item = inventory[selected_slot]; 
        
        if (_target_npc != noone) obj_game_manager.show_dialogue = true;
        if (_target_shop != noone) obj_game_manager.show_shop = true;
        
        // NHẬN HẠT GIỐNG VÀ CÔNG CỤ
        if (_target_table != noone) {
            if (_target_table.has_tools == true) {
                inventory[0] = 0; inventory_count[0] = 1; 
                inventory[1] = 1; inventory_count[1] = 1; 
                inventory[2] = 2; inventory_count[2] = 6; 
                
                for(var t=3; t<10; t++) { inventory[t] = -1; inventory_count[t] = 0; }
                
                _target_table.has_tools = false;
            }
        }
        
        // BÁN NÔNG SẢN
        if (_target_bin != noone) {
            if (_current_item == 7 || _current_item == 11) { // Bán Cà chua thường hoặc Hạng A
                var _sell_amount = inventory_count[selected_slot];
                var _earned = _sell_amount * obj_game_manager.item_prices[_current_item]; 
                
                coins += _earned;
                inventory[selected_slot] = -1;
                inventory_count[selected_slot] = 0;
                
                // PHÁT ÂM THANH NHẬN TIỀN
                audio_play_sound(snd_coin, 1, false);
                effect_create_above(ef_ring, _target_bin.x + 32, _target_bin.y + 32, 1, c_yellow);
            }
        }
        
        // ĐI NGỦ QUA NGÀY MỚI
        if (_target_bed != noone) {
            obj_game_manager.reset_shop(); 
            obj_game_manager.day_count += 1; // CẬP NHẬT NGÀY MỚI
            effect_create_above(ef_star, x + 32, y, 2, c_yellow);
            
            // Hồi phục 50 thức ăn khi đi ngủ
            hunger += 50; 
            if (hunger > 100) hunger = 100;

            var _rain_chance = irandom(99); 
            if (_rain_chance < 30) obj_game_manager.is_raining = true; else obj_game_manager.is_raining = false;

            with (obj_dirt) {
                if (obj_game_manager.is_raining == true) is_watered = true; else is_watered = false; 
                
                // TỈ LỆ 20% SINH SÂU BỆNH QUA ĐÊM (Nếu đang có cây)
                if (plant_stage > 0 && plant_stage < 4) {
                    if (irandom(100) < 20) {
                        is_infected = true;
                    }
                }
                
                // TỈ LỆ 15% MỌC CỎ DẠI QUA ĐÊM (Nếu đất đã cuốc)
                if (state == 1 && has_weed == false) {
                    if (irandom(100) < 15) {
                        has_weed = true;
                    }
                }
            }
            
            // --- TỰ ĐỘNG LƯU GAME VÀO ĐÚNG SLOT KHI ĐI NGỦ ---
            obj_game_manager.save_game(global.current_save_file, global.player_name);
        }
        
        // ==========================================
        // TƯƠNG TÁC ĐẤT VÀ VUNG TAY
        // ==========================================
        if (_target_dirt != noone) {
            action_timer = 15; 
            
            // 1. THU HOẠCH NÔNG SẢN (Chỉ khi Giai đoạn 3)
            if (_target_dirt.plant_stage == 3) {
                var _crop_id = 7; // Mặc định Cà Chua thường (Hạng B)
                var _yield = 1; 
                
                // HỆ THỐNG PHÂN LOẠI CHẤT LƯỢNG
                if (_target_dirt.is_fertilized == true && _target_dirt.is_neglected == false) {
                    _crop_id = 11; // Chuyển thành Cà chua Hạng A
                    _yield = 3;    // Năng suất cao
                    show_debug_message("Tuyệt vời! Thu hoạch Cà Chua Hạng A!");
                    effect_create_above(ef_star, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_yellow); // Hiệu ứng sao vàng
                } else {
                    show_debug_message("Thu hoạch Cà Chua thường.");
                    effect_create_above(ef_star, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_green);
                }
                
                if (_target_dirt.plant_type == 3) _crop_id = 3; // Nếu là ngô, trả lại ngô (tạm thời)
                
                var _found_slot = -1;
                var _empty_slot = -1;
                
                for(var k = 0; k < 10; k++) {
                    if (inventory[k] == _crop_id) { _found_slot = k; break; }
                    if (inventory[k] == -1 && _empty_slot == -1) { _empty_slot = k; }
                }
                
                if (_found_slot != -1) {
                    inventory_count[_found_slot] += _yield;
                } else if (_empty_slot != -1) {
                    inventory[_empty_slot] = _crop_id;
                    inventory_count[_empty_slot] = _yield;
                }
                
                // Trả đất về trạng thái trống
                _target_dirt.plant_stage = 0; 
                _target_dirt.is_fertilized = false; 
                _target_dirt.is_infected = false; 
                _target_dirt.has_weed = false;
                _target_dirt.is_neglected = false; // Reset lại lịch sử bỏ bê
                _target_dirt.growth_timer = 0;
                _target_dirt.rot_timer = 0;
            }
            // 2. SỬ DỤNG CÔNG CỤ HOẶC HẠT GIỐNG
            else { 
                if (_current_item == 0) { // CẦM CUỐC
                    if (_target_dirt.state == 0) {
                        _target_dirt.state = 1; 
                        hunger -= 5; 
                        if (hunger < 0) hunger = 0;
                        
                        // PHÁT ÂM THANH CUỐC ĐẤT
                        audio_play_sound(snd_hoe, 1, false);
                        effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_gray);
                    }
                }
                else if (_current_item == 1) { // CẦM BÌNH TƯỚI
                    if (_target_dirt.state == 1) {
                        _target_dirt.is_watered = true; 
                        hunger -= 5; 
                        if (hunger < 0) hunger = 0;
                        
                        // PHÁT ÂM THANH TƯỚI NƯỚC
                        audio_play_sound(snd_water, 1, false);
                        effect_create_above(ef_ring, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_aqua);
                        effect_create_above(ef_spark, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_blue);
                    }
                }
                else if (_current_item == 2 || _current_item == 3) { // CẦM HẠT GIỐNG
                    if (_target_dirt.state == 1 && _target_dirt.plant_stage == 0 && _target_dirt.has_weed == false) {
                        _target_dirt.plant_stage = 1; 
                        _target_dirt.plant_type = _current_item; // NHỚ LOẠI CÂY
                        
                        if (_current_item == 2) _target_dirt.growth_max = 600; 
                        else _target_dirt.growth_max = 1200;                   
                        
                        inventory_count[selected_slot] -= 1;
                        if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1; 
                    } else if (_target_dirt.has_weed == true) {
                        show_debug_message("Đất có cỏ dại, không thể gieo hạt!");
                    }
                }
                else if (_current_item == 8) { // CẦM PHÂN BÓN
                    if (_target_dirt.state == 1 && _target_dirt.is_fertilized == false && _target_dirt.plant_stage == 0 && _target_dirt.has_weed == false) {
                        _target_dirt.is_fertilized = true; 
                        
                        inventory_count[selected_slot] -= 1;
                        if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1; 
                        
                        effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_white); 
                    } else if (_target_dirt.has_weed == true) {
                        show_debug_message("Đất có cỏ dại, không thể bón phân!");
                    }
                }
                else if (_current_item == 9) { // CẦM THUỐC SINH HỌC
                    if (_target_dirt.is_infected == true) {
                        _target_dirt.is_infected = false; 
                        _target_dirt.rot_timer = 0; 
                        
                        inventory_count[selected_slot] -= 1;
                        if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1; 
                        
                        effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_lime);
                    }
                }
                else if (_current_item == 10) { // CẦM CÁI LIỀM
                    if (_target_dirt.has_weed == true || _target_dirt.plant_stage == 4) {
                        
                        if (_target_dirt.plant_stage == 4) {
                            _target_dirt.plant_stage = 0; 
                            _target_dirt.is_fertilized = false; 
                            _target_dirt.is_infected = false; 
                            _target_dirt.is_neglected = false;
                            _target_dirt.growth_timer = 0;
                            _target_dirt.rot_timer = 0;
                            effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_dkgray);
                        }
                        
                        if (_target_dirt.has_weed == true) {
                            _target_dirt.has_weed = false;
                            effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_green);
                        }
                        
                        hunger -= 2;
                        if (hunger < 0) hunger = 0;
                        
                        // PHÁT ÂM THANH XÀO XẠC KHI DÙNG LIỀM DỌN CỎ
                        audio_play_sound(snd_hoe, 1, false);
                    }
                }
            } 
        }
        
        // NHẶT ĐỒ TRANG TRÍ
        else if (_target_deco != noone) {
            action_timer = 15;
            var _found_slot = -1;
            var _empty_slot = -1;
            for(var k = 0; k < 10; k++) {
                if (inventory[k] == _target_deco.item_id) { _found_slot = k; break; }
                if (inventory[k] == -1 && _empty_slot == -1) { _empty_slot = k; }
            }
            
            if (_found_slot != -1) {
                inventory_count[_found_slot] += 1;
                instance_destroy(_target_deco);
            } else if (_empty_slot != -1) {
                inventory[_empty_slot] = _target_deco.item_id;
                inventory_count[_empty_slot] = 1;
                instance_destroy(_target_deco);
            }
        }
        
        // ĐẶT ĐỒ TRANG TRÍ
        else if (_current_item >= 4 && _current_item <= 6) {
            if (_target_bed == noone && _target_dirt == noone && _target_bin == noone && _target_shop == noone && _target_table == noone && _target_npc == noone && _target_solid == noone) {
                action_timer = 15;
                var _place_x = floor(_interact_x / 64) * 64;
                var _place_y = floor(_interact_y / 64) * 64;
                var _new_deco = instance_create_layer(_place_x, _place_y, "Instances", obj_decoration);
                _new_deco.item_id = _current_item; 
                
                inventory_count[selected_slot] -= 1;
                if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1;
            }
        }
    } 
}