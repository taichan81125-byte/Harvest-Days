if (room != rm_farm && room != rm_house && room != rm_city) exit;

depth = -bbox_bottom;
// ĐẶC QUYỀN ADMIN
if (global.current_save_file == "slot4.ini") {
    coins = 9999999;
    if (keyboard_check_pressed(ord("R"))) {
        obj_game_manager.reset_shop();
        effect_create_above(ef_ring, x, y, 1, c_yellow);
    }
}

// THÊM BIẾN is_paused ĐỂ KHÓA DI CHUYỂN VÀ HOTBAR KHI PAUSE
var _is_ui_open = (obj_game_manager.show_dialogue == true || obj_game_manager.show_shop == true || obj_game_manager.is_paused == true);

if (_is_ui_open == false) {

    // ==========================================
    // HỆ THỐNG SINH TỒN (TRỪ ĐÓI, MẤT MÁU, NGẤT XỈU)
    // ==========================================
    // 1. (Đã bỏ trừ thức ăn theo thời gian)

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
        
        // Qua ngày mới (chạy thẳng tới 6h sáng hôm sau)
        var _cur_h = obj_game_manager.game_hour;
        var _hours_diff = 0;
        if (_cur_h >= 6) _hours_diff = 24 - _cur_h + 6;
        else _hours_diff = 6 - _cur_h;
        
        var _minutes_diff = -obj_game_manager.game_minute;
        var _total_hours_passed = _hours_diff + (_minutes_diff / 60);
        
        obj_game_manager.game_minute = 0;
        obj_game_manager.advance_time(_total_hours_passed);
        obj_game_manager.game_hour = 6;
        
        // --- TỰ ĐỘNG LƯU GAME SAU KHI NGẤT XỈU VÀO ĐÚNG SLOT ĐANG CHƠI ---
        obj_game_manager.save_game(global.current_save_file, global.player_name);
        
        show_debug_message("BẠN ĐÃ NGẤT XỈU! Bị trừ 10 Vàng viện phí và mất một ngày.");
    }

    // ==========================================
    // TÍNH NĂNG ĂN UỐNG (PHÍM E)
    // ==========================================
    if (keyboard_check_pressed(ord("E")) && selected_slot != -1) {
        var _current_item = inventory[selected_slot];
        if (_current_item >= 18 && _current_item <= 26) { // Ăn nông sản
            if (hunger < 100 || hp < 3) {
                var _hunger_heal = 30; // Thường hồi 30
                var _hp_heal = 1;      // Thường hồi 1
                
                hunger += _hunger_heal; 
                if (hunger > 100) hunger = 100;
                hp += _hp_heal;  
                if (hp > 3) hp = 3;
                
                // Trừ nông sản trong túi
                inventory_count[selected_slot] -= 1;
                if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1;
                
                // PHÁT ÂM THANH ĂN UỐNG
                audio_play_sound(snd_eat, 1, false);
                effect_create_above(ef_star, x, y + 10, 1, c_lime);
                show_debug_message("Đã ăn Nông Sản! Hồi máu và thức ăn.");
            } else {
                show_debug_message("Bạn đang no, không cần ăn thêm!");
            }
        }
    }

    // ==========================================
    // CHỌN CÔNG CỤ & POPUP
    // ==========================================
    var _slot_changed = false;
    if (keyboard_check_pressed(ord("1"))) { if (selected_slot == 0) selected_slot = -1; else selected_slot = 0; _slot_changed = true; }
    if (keyboard_check_pressed(ord("2"))) { if (selected_slot == 1) selected_slot = -1; else selected_slot = 1; _slot_changed = true; }
    if (keyboard_check_pressed(ord("3"))) { if (selected_slot == 2) selected_slot = -1; else selected_slot = 2; _slot_changed = true; }
    if (keyboard_check_pressed(ord("4"))) { if (selected_slot == 3) selected_slot = -1; else selected_slot = 3; _slot_changed = true; }
    if (keyboard_check_pressed(ord("5"))) { if (selected_slot == 4) selected_slot = -1; else selected_slot = 4; _slot_changed = true; }
    if (keyboard_check_pressed(ord("6"))) { if (selected_slot == 5) selected_slot = -1; else selected_slot = 5; _slot_changed = true; }
    if (keyboard_check_pressed(ord("7"))) { if (selected_slot == 6) selected_slot = -1; else selected_slot = 6; _slot_changed = true; }
    if (keyboard_check_pressed(ord("8"))) { if (selected_slot == 7) selected_slot = -1; else selected_slot = 7; _slot_changed = true; }
    if (keyboard_check_pressed(ord("9"))) { if (selected_slot == 8) selected_slot = -1; else selected_slot = 8; _slot_changed = true; }
    if (keyboard_check_pressed(ord("0"))) { if (selected_slot == 9) selected_slot = -1; else selected_slot = 9; _slot_changed = true; }

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
                        if (add_item(_item_id, _buy_count)) {
                            coins -= _price;
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
// CẬP NHẬT GRID MOUSE VÀ TÍNH HỢP LỆ
// ==========================================
mouse_tile_x = floor(mouse_x / 64) * 64;
mouse_tile_y = floor(mouse_y / 64) * 64;

var _dist = point_distance(x, y, mouse_tile_x + 32, mouse_tile_y + 32);
is_mouse_in_reach = (_dist <= 120);

// Kiểm tra tính hợp lệ sơ bộ của ô
is_action_valid = false;
var _target_bed = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_bed, false, true);
var _target_dirt = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_dirt, false, true);
var _target_bin = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_bin, false, true);
var _target_npc = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_npc_moc, false, true);
var _target_shop = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_shop, false, true);
var _target_table = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_table, false, true);
var _target_deco = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_decoration, false, true);
var _target_solid = collision_circle(mouse_tile_x + 32, mouse_tile_y + 32, 10, obj_solid, false, true);

if (keyboard_check_pressed(vk_space)) {
    if (_target_bed == noone) {
        _target_bed = collision_circle(x, y, 96, obj_bed, false, true);
    }
    if (_target_bed != noone) {
        is_mouse_in_reach = true;
    }
}

var _current_item = -1;
if (selected_slot != -1) _current_item = inventory[selected_slot]; 

if (_current_item == 0) { // Cuốc
    if (_target_solid == noone && _target_dirt == noone && _target_bed == noone && _target_bin == noone && _target_shop == noone && _target_table == noone && _target_npc == noone) is_action_valid = true;
} else if (_current_item == 1) { // Bình tưới
    if (_target_dirt != noone && _target_dirt.state == 1) is_action_valid = true;
} else if (_current_item >= 9 && _current_item <= 17) { // Hạt giống
    if (_target_dirt != noone && _target_dirt.state == 1 && _target_dirt.plant_stage == 0 && _target_dirt.has_weed == false) is_action_valid = true;
} else if (_current_item >= 6 && _current_item <= 8) { // Đồ trang trí
    if (_target_solid == noone && _target_dirt == noone && _target_bed == noone && _target_bin == noone && _target_shop == noone && _target_table == noone && _target_npc == noone) is_action_valid = true;
} else if (_current_item == 4) { // Phân bón
    if (_target_dirt != noone && _target_dirt.state == 1 && _target_dirt.is_fertilized == false && _target_dirt.plant_stage == 0 && _target_dirt.has_weed == false) is_action_valid = true;
} else if (_current_item == 5) { // Thuốc sinh học
    if (_target_dirt != noone && _target_dirt.is_infected == true) is_action_valid = true;
} else if (_current_item == 2) { // Liềm
    if (_target_dirt != noone && (_target_dirt.has_weed == true || _target_dirt.plant_stage == 4)) is_action_valid = true;
} else if (_current_item == 3) { // Xẻng
    if (_target_dirt != noone && _target_dirt.plant_stage > 0) is_action_valid = true;
}

// Luôn cho phép valid nếu nhấp vào NPC, giường, thùng, bàn, đồ trang trí, nông sản đã chín
if (_target_npc != noone || _target_bed != noone || _target_bin != noone || _target_table != noone || _target_shop != noone || _target_deco != noone) {
    is_action_valid = true;
}
if (_target_dirt != noone && _target_dirt.plant_stage == 3) { // Thu hoạch nông sản
    is_action_valid = true;
}

if (!is_mouse_in_reach) is_action_valid = false;

// ==========================================
// TƯƠNG TÁC BẰNG CHUỘT HOẶC SPACE VỚI MÔI TRƯỜNG
// ==========================================
var _is_ui_click = false;
if (mouse_check_button_pressed(mb_left) && obj_game_manager.is_paused == false) {
    var _gui_y = device_mouse_y_to_gui(0);
    var _gui_x = device_mouse_x_to_gui(0);
    if (_gui_y >= 650 && _gui_y <= 700 && _gui_x >= 340 && _gui_x <= 940) { 
        _is_ui_click = true;
        var _clicked_slot = floor((_gui_x - 340) / 60);
        if (_clicked_slot > 9) _clicked_slot = 9;
        if (selected_slot == _clicked_slot) selected_slot = -1; else selected_slot = _clicked_slot;
        item_popup_timer = 90;
    }
}

if ((keyboard_check_pressed(vk_space) || (mouse_check_button_pressed(mb_left) && !_is_ui_click)) && obj_game_manager.is_paused == false) {
    if (obj_game_manager.show_dialogue == true) {
        obj_game_manager.show_dialogue = false;
    }
    else if (is_mouse_in_reach) {
        // Cập nhật hướng quay mặt theo hướng click
        var _dir = point_direction(x, y, mouse_tile_x + 32, mouse_tile_y + 32);
        if (_dir >= 45 && _dir < 135) facing_dir = 90;
        else if (_dir >= 135 && _dir < 225) facing_dir = 180;
        else if (_dir >= 225 && _dir < 315) facing_dir = 270;
        else facing_dir = 0;
        
        var _interact_x = mouse_tile_x + 32;
        var _interact_y = mouse_tile_y + 32;

        if (_target_npc != noone) obj_game_manager.show_dialogue = true;
        if (_target_shop != noone) obj_game_manager.show_shop = true;
        
        if (_target_table != noone) {
            if (_target_table.has_tools == true) {
                var _items_to_give = [
                    [0, 1], // Cuốc
                    [1, 1], // Bình tưới
                    [2, 1], // Liềm
                    [3, 1], // Xẻng
                    [4, 1], // Phân bón
                    [5, 1], // Thuốc sinh học
                    [13, 5], // 5 Hạt Việt Quất (Mùa Hạ)
                    [14, 5]  // 5 Hạt Dưa Hấu (Mùa Hạ)
                ];
                
                for (var i = 0; i < array_length(_items_to_give); i++) {
                    var _id = _items_to_give[i][0];
                    var _amt = _items_to_give[i][1];
                    var _found = -1;
                    var _empty = -1;
                    
                    for (var k = 0; k < 10; k++) {
                        if (inventory[k] == _id) { _found = k; break; }
                        if (inventory[k] == -1 && _empty == -1) { _empty = k; }
                    }
                    
                    if (_found != -1) {
                        inventory_count[_found] += _amt;
                    } else if (_empty != -1) {
                        inventory[_empty] = _id;
                        inventory_count[_empty] = _amt;
                    }
                }
                
                _target_table.has_tools = false;
                array_push(obj_game_manager.night_events, "+ Nhận được bộ dụng cụ và hạt giống mùa hạ!");
            }
        }
        
        // BÁN NÔNG SẢN
        if (_target_bin != noone) {
            if (_current_item >= 18 && _current_item <= 26) { // Bán nông sản
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
        
        // ĐI NGỦ
        if (_target_bed != noone) {
            var _cur_h = obj_game_manager.game_hour;
            if (_cur_h >= 18 || _cur_h < 6 || global.current_save_file == "slot4.ini") {
                var _hours_diff = 0;
                if (_cur_h >= 6) _hours_diff = 24 - _cur_h + 6;
                else _hours_diff = 6 - _cur_h;
                
                var _minutes_diff = -obj_game_manager.game_minute;
                var _total_hours_passed = _hours_diff + (_minutes_diff / 60);
                
                obj_game_manager.game_minute = 0;
                obj_game_manager.advance_time(_total_hours_passed);
                obj_game_manager.game_hour = 6;
                
                effect_create_above(ef_star, x + 32, y, 2, c_yellow);
                
                hunger += 50; 
                if (hunger > 100) hunger = 100;
                
                obj_game_manager.save_game(global.current_save_file, global.player_name);
            } else {
                obj_game_manager.show_dialogue = true;
                obj_game_manager.dialogue_text = "Trời vẫn còn sáng, chưa thể ngủ được!";
            }
        }
        
        // TƯƠNG TÁC ĐẤT VÀ VUNG TAY
        if (_target_dirt != noone) {
            
            // THU HOẠCH NÔNG SẢN
            if (_target_dirt.plant_stage == 3) {
                action_timer = 15;
                hunger -= 1;
                if (hunger < 0) hunger = 0;
                var _crop_id = _target_dirt.plant_type + 9;
                var _yield = 1; 
                
                if (_target_dirt.is_neglected == true) {
                    _yield = 1; effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_gray);
                } else if (_target_dirt.is_fertilized == true) {
                    _yield = 3; effect_create_above(ef_star, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_yellow);
                } else {
                    _yield = 2; effect_create_above(ef_star, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_green);
                }
                
                add_item(_crop_id, _yield);
                
                _target_dirt.plant_stage = 0; 
                _target_dirt.is_fertilized = false; 
                _target_dirt.is_infected = false; 
                _target_dirt.is_neglected = false; 
                _target_dirt.growth_timer = 0;
                _target_dirt.rot_timer = 0;
            }
            // SỬ DỤNG CÔNG CỤ HOẶC HẠT GIỐNG
            else if (is_action_valid) { 
                action_timer = 15;
                
                hunger -= 1;
                if (hunger < 0) hunger = 0;
                
                if (_current_item == 1) { // Bình tưới
                    _target_dirt.is_watered = true; 
                    audio_play_sound(snd_water, 1, false);
                    effect_create_above(ef_ring, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_aqua);
                    effect_create_above(ef_spark, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_blue);
                }
                else if (_current_item >= 9 && _current_item <= 17) { // Hạt giống
                    _target_dirt.plant_stage = 1; 
                    _target_dirt.plant_type = _current_item; 
                    if (_current_item == 9 || _current_item == 12 || _current_item == 14) _target_dirt.growth_max = 1800; // 2 stages * 1800 = 3600
                    else _target_dirt.growth_max = 3600; // 2 stages * 3600 = 7200
                    
                    inventory_count[selected_slot] -= 1;
                    if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1; 
                }
                else if (_current_item == 4) { // Phân bón
                    _target_dirt.is_fertilized = true; 
                    inventory_count[selected_slot] -= 1;
                    if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1; 
                    effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 0, c_white); 
                }
                else if (_current_item == 5) { // Thuốc sinh học
                    _target_dirt.is_infected = false; 
                    _target_dirt.rot_timer = 0; 
                    inventory_count[selected_slot] -= 1;
                    if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1; 
                    effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_lime);
                }
                else if (_current_item == 2) { // Liềm
                    if (_target_dirt.has_weed == true || _target_dirt.plant_stage == 4) {
                        _target_dirt.has_weed = false;
                        if (_target_dirt.plant_stage == 4) {
                            _target_dirt.plant_stage = 0;
                            _target_dirt.is_fertilized = false;
                            _target_dirt.is_infected = false;
                            _target_dirt.is_neglected = false;
                            _target_dirt.growth_timer = 0;
                            _target_dirt.rot_timer = 0;
                        }
                        effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_green);
                        audio_play_sound(snd_hoe, 1, false);
                    }
                }
                else if (_current_item == 3) { // Xẻng
                    _target_dirt.plant_stage = 0; 
                    _target_dirt.is_fertilized = false; 
                    _target_dirt.is_infected = false; 
                    _target_dirt.is_neglected = false;
                    _target_dirt.has_weed = false;
                    _target_dirt.growth_timer = 0;
                    _target_dirt.rot_timer = 0;
                    effect_create_above(ef_smoke, _target_dirt.x + 32, _target_dirt.y + 32, 1, c_dkgray);
                    audio_play_sound(snd_hoe, 1, false);
                }
            } 
        }
        
        // CUỐC ĐẤT TRỐNG (Tạo obj_dirt)
        else if (is_action_valid && _current_item == 0) {
            action_timer = 15;
            var _new_dirt = instance_create_layer(mouse_tile_x, mouse_tile_y, "Instances", obj_dirt);
            _new_dirt.state = 1;
            hunger -= 1; 
            if (hunger < 0) hunger = 0;
            audio_play_sound(snd_hoe, 1, false);
            effect_create_above(ef_smoke, mouse_tile_x + 32, mouse_tile_y + 32, 1, c_gray);
        }
        
        // NHẶT ĐỒ TRANG TRÍ
        else if (_target_deco != noone) {
            action_timer = 15;
            hunger -= 1; 
            if (hunger < 0) hunger = 0;
            if (add_item(_target_deco.item_id, 1)) {
                instance_destroy(_target_deco);
            }
        }
        
        // ĐẶT ĐỒ TRANG TRÍ
        else if (_current_item >= 6 && _current_item <= 8 && is_action_valid) {
            action_timer = 15;
            hunger -= 1; 
            if (hunger < 0) hunger = 0;
            var _new_deco = instance_create_layer(mouse_tile_x, mouse_tile_y, "Instances", obj_decoration);
            _new_deco.item_id = _current_item; 
            
            inventory_count[selected_slot] -= 1;
            if (inventory_count[selected_slot] <= 0) inventory[selected_slot] = -1;
        }
    } 
}