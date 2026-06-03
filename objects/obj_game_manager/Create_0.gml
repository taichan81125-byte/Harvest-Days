// Tránh tạo bản sao khi quay lại phòng có game_manager trong Room Editor
if (instance_number(obj_game_manager) > 1) {
    instance_destroy();
    exit;
}

// Đặt depth = 199 để vẽ background đè lên lớp Background (200) nhưng nằm DƯỚI obj_dirt (99) và obj_player (<0)
depth = 199;

// Đổi con trỏ chuột sang sprite mới và ẩn con trỏ chuột hệ thống
// Xóa cursor_sprite để vẽ thủ công to hơn
window_set_cursor(cr_none);

// Biến kiểm tra xem hộp thoại có đang mở không (mặc định là tắt)
show_dialogue = false;

// Biến kiểm tra bảng cài đặt (mặc định là tắt)
show_settings = false;

// Biến kiểm tra kho đồ cá nhân
show_inventory = false;
drag_item_id = -1;
drag_item_count = 0;
drag_src_type = -1; // 0: hotbar, 1: bag
drag_src_index = -1;

// Nội dung bức thư của Bác Mộc đã có Tiếng Việt
dialogue_text = "Chào cháu, người bạn trẻ!\nKhu vườn này đang ngủ say, ta tin cháu có thể đánh thức nó.\nHãy lấy các dụng cụ trên chiếc bàn bên cạnh để bắt đầu công việc nhé.\nChúc cháu may mắn với Ngày Thu Hoạch!";

// Biến bật/tắt UI cửa hàng
show_shop = false;

// Biến đếm ngày và thời tiết
day_count = 1;
is_raining = false;

// ==========================================
// HỆ THỐNG ĐỒNG HỒ SINH HỌC (BIOLOGICAL CLOCK)
// ==========================================
game_hour = 6;              // Giờ hiện tại (0-23), bắt đầu lúc 6h sáng
game_minute = 0;            // Phút hiện tại (0-59)
time_ticker = 0;            // Bộ đếm frame nội bộ
frames_per_game_minute = (global.current_save_file == "slot4.ini") ? 2 : 5; // Admin thời gian trôi siêu tốc (gấp 2.5 lần)

// Hiệu ứng ngày/đêm
day_overlay_alpha = 0;      // Độ tối của lớp phủ
day_overlay_color = c_black; // Màu lớp phủ

// Đặt tâm của mặt đồng hồ và kim đồng hồ vào chính giữa (vì ảnh gốc 450x450)
sprite_set_offset(spr_mat_dong_ho, 225, 225);
sprite_set_offset(spr_kim_dong_ho, 225, 245);

// Khung thời gian giữ offset 0,0 (góc trên bên trái)

// Tải sprite Cà Chua Hạng B (Làm tối từ Cà Chua thường)
spr_crop_tomato_b = sprite_add(working_directory + "CaChuaHangB.png", 1, false, false, 0, 0);

// Tải hình nền nhà nông dân
global.spr_house_bg = sprite_add(working_directory + "house_interior.png", 1, false, false, 0, 0);
if (global.spr_house_bg == -1) {
    show_debug_message("CẢNH BÁO: Không tìm thấy file house_interior.png trong thư mục datafiles!");
}
night_events = [];
show_notifications = false;
farm_dirt_data = [];

// ==========================================
// TẢI MAP MÙA (SEASONAL MAP SPRITES) - NÔNG TRẠI
// ==========================================
global.spr_map_xuan = sprite_add("xuan.png", 1, false, false, 0, 0);
global.spr_map_ha = sprite_add("ha.png", 1, false, false, 0, 0);
global.spr_map_thu = sprite_add("thu.png", 1, false, false, 0, 0);
global.spr_map_dong = sprite_add("dong.png", 1, false, false, 0, 0);

season_map_sprites[0] = global.spr_map_ha;   // 0 = Hạ (Summer)
season_map_sprites[1] = global.spr_map_thu;  // 1 = Thu (Autumn)
season_map_sprites[2] = global.spr_map_dong; // 2 = Đông (Winter)
season_map_sprites[3] = global.spr_map_xuan; // 3 = Xuân (Spring)

// ==========================================
// TẢI MAP MÙA - THÀNH PHỐ
// ==========================================
global.spr_city_xuan = sprite_add(working_directory + "city_xuan.png", 1, false, false, 0, 0);
global.spr_city_ha = sprite_add(working_directory + "city_ha.png", 1, false, false, 0, 0);
global.spr_city_thu = sprite_add(working_directory + "city_thu.png", 1, false, false, 0, 0);
global.spr_city_dong = sprite_add(working_directory + "city_dong.png", 1, false, false, 0, 0);

season_city_sprites[0] = global.spr_city_ha;
season_city_sprites[1] = global.spr_city_thu;
season_city_sprites[2] = global.spr_city_dong;
season_city_sprites[3] = global.spr_city_xuan;

function advance_time(_hours) {
    // Reset thông báo nếu qua đêm
    if (_hours >= 6) {
        night_events = [];
    }
    game_hour += _hours;
    var _days_passed = 0;
    while (game_hour >= 24) {
        game_hour -= 24;
        _days_passed += 1;
    }
    
    if (_days_passed > 0) {
        day_count += _days_passed;
        current_season = ((day_count - 1) div 28) % 4;
        reset_shop();
        
        var _rain_chance = irandom(99); 
        if (_rain_chance < 30) is_raining = true; else is_raining = false;
        
        var _withered_count = 0;
        
        if (room == rm_farm) {
            farm_dirt_data = [];
            with (obj_dirt) {
                array_push(other.farm_dirt_data, {
                    _x: x, _y: y, _state: state, _is_watered: is_watered, _is_fertilized: is_fertilized,
                    _is_infected: is_infected, _has_weed: has_weed, _is_neglected: is_neglected,
                    _plant_stage: plant_stage, _plant_type: plant_type, _growth_timer: growth_timer, _rot_timer: rot_timer
                });
            }
        }
        
        for (var i = 0; i < array_length(farm_dirt_data); i++) {
            var _d = farm_dirt_data[i];
            if (obj_game_manager.is_raining == true) {
                _d._is_watered = true;
            } else {
                if (_d._plant_stage == 0) _d._is_watered = false; 
            }
            
            if (_d._plant_stage == 3) {
                _d._plant_stage = 4;
                _withered_count++;
            }
        }
        
        if (_withered_count > 0) array_push(obj_game_manager.night_events, "- Có " + string(_withered_count) + " cây đã bị héo úa do không thu hoạch!");
    }
    
    // Đổ xúc xắc mọc cỏ dại cho mỗi giờ trôi qua
    var _weed_count = 0;
    for (var i = 0; i < floor(_hours); i++) {
        for (var j = 0; j < array_length(farm_dirt_data); j++) {
            var _d = farm_dirt_data[j];
            if (_d._state == 1 && _d._has_weed == false) {
                if (irandom(100) < 2) {
                    _d._has_weed = true;
                    _weed_count++;
                }
            }
        }
    }
    if (_weed_count > 0) array_push(obj_game_manager.night_events, "- Phát hiện " + string(_weed_count) + " đám cỏ dại mới mọc quanh nông trại.");
    
    // Tự động cho cây trồng lớn lên tương ứng với số thời gian bỏ qua
    var _frames_passed = _hours * 60 * 5; // Luôn dùng 5 (tốc độ gốc) để chuẩn hóa thời gian cây lớn
    for (var i = 0; i < array_length(farm_dirt_data); i++) {
        var _d = farm_dirt_data[i];
        if (_d._plant_stage > 0 && _d._plant_stage < 3) {
            var _req_season = 0;
            if (_d._plant_type >= 9 && _d._plant_type <= 12) _req_season = 0;
            else if (_d._plant_type >= 13 && _d._plant_type <= 14) _req_season = 1;
            else if (_d._plant_type >= 15 && _d._plant_type <= 16) _req_season = 2;
            else if (_d._plant_type == 17) _req_season = 3;
            var _can_grow = (obj_game_manager.current_season == _req_season);

            if (_can_grow == true && _d._is_watered == true && _d._is_infected == false) {
                _d._growth_timer += _frames_passed;
                // Giả lập behavior của obj_dirt: growth_max = 86400 (24h in game * 60m * 60s) hoặc 24 * 60 * 5 = 7200 frames!
                // Wait, in obj_dirt, growth_max is set based on type. I need to hardcode it or calculate it.
                // Let's assume standard growth_max for now (it's 7200 or 14400 frames usually)
                // Oh wait, in Create_0.gml of obj_dirt: growth_max = 7200; (1 ngày trong game)
                var _growth_max = 7200; 
                while (_d._growth_timer >= _growth_max && _d._plant_stage < 3) {
                    _d._plant_stage += 1;
                    if (_d._plant_stage == 3 && _d._has_weed == true) {
                        _d._is_neglected = true; 
                    }
                    _d._growth_timer -= _growth_max;
                    _d._rot_timer = 0;
                    
                    if (obj_game_manager.is_raining) {
                        _d._is_watered = true;
                    } else {
                        _d._is_watered = false;
                        _d._growth_timer = 0; 
                        break;
                    }
                }
            } 
            
            if (_d._is_infected == true) {
                _d._is_neglected = true;
                _d._rot_timer += _frames_passed;
                if (_d._rot_timer >= 3600) { 
                    _d._plant_stage = 4;
                }
            }
        } 
    }
    
    // Sâu bệnh chỉ sinh ra lúc 6h sáng (qua đêm)
    var _infected_count = 0;
    if (_days_passed > 0) {
        for (var i = 0; i < array_length(farm_dirt_data); i++) {
            var _d = farm_dirt_data[i];
            if (_d._plant_stage > 0 && _d._plant_stage < 3) {
                if (irandom(100) < 20) {
                    _d._is_infected = true;
                    _infected_count++;
                }
            }
        }
        if (_infected_count > 0) array_push(obj_game_manager.night_events, "- Ồ không! Có " + string(_infected_count) + " cây trồng đang bị sâu bệnh tấn công!");
    }
    
    // Nếu vẫn ở trong rm_farm (ví dụ admin cheat), recreate obj_dirt
    if (room == rm_farm) {
        with (obj_dirt) instance_destroy();
        for (var i = 0; i < array_length(farm_dirt_data); i++) {
            var _d = farm_dirt_data[i];
            var _inst = instance_create_layer(_d._x, _d._y, "Instances", obj_dirt);
            _inst.state = _d._state;
            _inst.is_watered = _d._is_watered;
            _inst.is_fertilized = _d._is_fertilized;
            _inst.is_infected = _d._is_infected;
            _inst.has_weed = _d._has_weed;
            _inst.is_neglected = _d._is_neglected;
            _inst.plant_stage = _d._plant_stage;
            _inst.plant_type = _d._plant_type;
            _inst.growth_timer = _d._growth_timer;
            _inst.rot_timer = _d._rot_timer;
        }
    }
}

// TÍNH NĂNG MỚI: MENU TẠM DỪNG VÀ CÀI ĐẶT
is_paused = false;
show_settings = false; // Bật/tắt bảng Cài đặt

// =====================================
// KHỞI TẠO CÁC BIẾN TOÀN CỤC CỦA TRÒ CHƠI
// =====================================

// Khóa kích thước GUI ở 1280x720 để con trỏ chuột luôn khớp với ô UI dù có thay đổi kích thước cửa sổ
display_set_gui_size(1280, 720);

// ==========================================
// HỆ THỐNG ÂM THANH TOÀN CỤC (GLOBAL AUDIO)
// ==========================================
if (!variable_global_exists("master_vol")) {
global.master_vol = 1.0;  // Âm lượng từ 0.0 đến 1.0 (100%)
global.is_muted = false;  // Trạng thái Tắt tiếng
audio_master_gain(global.master_vol);
}

// Bật nhạc nền lặp đi lặp lại (Loop) khi vào phòng Nông trại
if (room == rm_farm || room == rm_house || room == rm_city) {
if (!audio_is_playing(snd_bgm)) {
audio_play_sound(snd_bgm, 0, true);
}
}

// ========================================================
// KHO DỮ LIỆU VẬT PHẨM
// ========================================================
item_names = [
    "Cuốc", "Bình Tưới", "Cái Liềm", "Xẻng", "Phân Bón", "Thuốc Sinh Học", "Ghế Gỗ", "Chậu Hoa", "Đèn Lồng", 
    "Hạt Củ Cải Vàng", "Hạt Súp Lơ Trắng", "Hạt Đậu Xanh", "Hạt Khoai Tây", 
    "Hạt Việt Quất", "Hạt Dưa Hấu", 
    "Hạt Bí Ngô", "Hạt Nho", 
    "Hạt Khoai Mỡ",
    "Củ Cải Vàng", "Súp Lơ Trắng", "Đậu Xanh", "Khoai Tây", 
    "Việt Quất", "Dưa Hấu", 
    "Bí Ngô", "Nho", 
    "Khoai Mỡ"
];
item_prices = [
    0, 0, 15, 0, 8, 12, 50, 30, 100, 
    10, 15, 12, 10, 
    20, 25, 
    30, 35, 
    40,
    25, 35, 30, 25, 
    45, 55, 
    75, 80, 
    100
];
item_sprites = [
    spr_icon_hoe, spr_icon_water, spr_icon_sickle, spr_xeng, spr_icon_fertilizer, spr_icon_pesticide, spr_icon_chair, spr_icon_pot, spr_icon_lantern, 
    spr_hat_cu_cai_vang, spr_hat_sup_lo_trang, spr_hat_dau_xanh, spr_hat_khoai_tay, 
    spr_hat_viet_quat, spr_hat_dua_hau, 
    spr_hat_bi_ngo, spr_hat_nho, 
    spr_hat_khoai_mo,
    spr_cu_cai_vang, spr_sup_lo_trang, spr_dau_xanh, spr_khoai_tay, 
    spr_viet_quat, spr_dua_hau, 
    spr_bi_ngo, spr_nho, 
    spr_khoai_mo
];

current_season = ((day_count - 1) div 28) % 4; // 0=Xuân, 1=Hạ, 2=Thu, 3=Đông
daily_shop = [0, 0, 0, 0, 0];

// Biến chuyển mùa mượt mà (crossfade transition)
season_transition_active = false;
season_transition_alpha = 1.0;
season_transition_speed = 0.008; // ~125 frames ≈ 4 giây
prev_season = current_season;
season_transition_layer = -1;
season_transition_bg = -1;

// Hệ thống Particle mùa tùy chỉnh
season_particles = [];
max_particles = 40;
particle_spawn_timer = 0;

function reset_shop() {
    for(var i = 0; i < 5; i++) {
        var _season_seeds = [];
        if (current_season == 0) _season_seeds = [9, 10, 11, 12];
        else if (current_season == 1) _season_seeds = [13, 14];
        else if (current_season == 2) _season_seeds = [15, 16];
        else if (current_season == 3) _season_seeds = [17];
        
        // Random ra vật phẩm thường hoặc hạt giống theo mùa
        var _choices = [4, 5, 6, 7, 8];
        array_copy(_choices, array_length(_choices), _season_seeds, 0, array_length(_season_seeds));
        
        daily_shop[i] = _choices[irandom(array_length(_choices) - 1)];
    }
}

reset_shop();

// ==========================================
// HỆ THỐNG LƯU / TẢI GAME (NÂNG CẤP MULTI-SAVE)
// ==========================================
owner_name = "Người chơi mới";

function save_game(_file_name, _player_name) {
if (_file_name == undefined) _file_name = "harvest_save_default.ini";
if (_player_name == undefined) _player_name = owner_name;

ini_open(_file_name);

ini_write_string("Info", "owner_name", _player_name);
ini_write_real("Player", "coins", obj_player.coins);
ini_write_real("Player", "hunger", obj_player.hunger);
ini_write_real("Player", "hp", obj_player.hp);

for(var i = 0; i < 10; i++) {
    ini_write_real("Inventory", "item_" + string(i), obj_player.inventory[i]);
    ini_write_real("Inventory", "count_" + string(i), obj_player.inventory_count[i]);
}
for(var i = 0; i < 20; i++) {
    ini_write_real("Bag", "item_" + string(i), obj_player.bag[i]);
    ini_write_real("Bag", "count_" + string(i), obj_player.bag_count[i]);
}

ini_write_real("Game", "day_count", day_count);
ini_write_real("Game", "game_hour", game_hour);
ini_write_real("Game", "game_minute", game_minute);

// Lưu dữ liệu đất cuốc
if (room == rm_farm) {
    farm_dirt_data = [];
    with (obj_dirt) {
        array_push(other.farm_dirt_data, {
            _x: x, _y: y, _state: state, _is_watered: is_watered, _is_fertilized: is_fertilized,
            _is_infected: is_infected, _has_weed: has_weed, _is_neglected: is_neglected,
            _plant_stage: plant_stage, _plant_type: plant_type, _growth_timer: growth_timer, _rot_timer: rot_timer
        });
    }
}
ini_write_real("DirtSystem", "count", array_length(farm_dirt_data));
for (var i = 0; i < array_length(farm_dirt_data); i++) {
    var _d = farm_dirt_data[i];
    var _key = "Dirt_" + string(i);
    ini_write_real(_key, "x", _d._x);
    ini_write_real(_key, "y", _d._y);
    ini_write_real(_key, "state", _d._state);
    ini_write_real(_key, "is_watered", _d._is_watered);
    ini_write_real(_key, "is_fertilized", _d._is_fertilized);
    ini_write_real(_key, "is_infected", _d._is_infected);
    ini_write_real(_key, "has_weed", _d._has_weed);
    ini_write_real(_key, "is_neglected", _d._is_neglected);
    ini_write_real(_key, "plant_stage", _d._plant_stage);
    ini_write_real(_key, "plant_type", _d._plant_type);
    ini_write_real(_key, "growth_timer", _d._growth_timer);
    ini_write_real(_key, "rot_timer", _d._rot_timer);
}

ini_close();


}

function load_game(_file_name) {
if (_file_name == undefined) _file_name = "harvest_save_default.ini";

if (file_exists(_file_name)) {
    ini_open(_file_name);

    owner_name = ini_read_string("Info", "owner_name", "Người chơi mới");
    obj_player.coins = ini_read_real("Player", "coins", 100);
    obj_player.hunger = ini_read_real("Player", "hunger", 100);
    obj_player.hp = ini_read_real("Player", "hp", 3);

    for(var i = 0; i < 10; i++) {
        obj_player.inventory[i] = ini_read_real("Inventory", "item_" + string(i), -1);
        obj_player.inventory_count[i] = ini_read_real("Inventory", "count_" + string(i), 0);
    }
    for(var i = 0; i < 20; i++) {
        obj_player.bag[i] = ini_read_real("Bag", "item_" + string(i), -1);
        obj_player.bag_count[i] = ini_read_real("Bag", "count_" + string(i), 0);
    }

    day_count = ini_read_real("Game", "day_count", 1);
    current_season = ((day_count - 1) div 28) % 4; // Tính lại mùa
    game_hour = ini_read_real("Game", "game_hour", 6);
    game_minute = ini_read_real("Game", "game_minute", 0);

    // Tải dữ liệu đất cuốc
    farm_dirt_data = [];
    var _count = ini_read_real("DirtSystem", "count", 0);
    
    // Hỗ trợ lưu trữ cũ (fallback for old saves)
    if (_count == 0 && ini_section_exists("DirtSystem") == false) {
        // Old saves won't load dirt automatically if saved in house, 
        // but if they saved in farm somehow, it would be missed.
        // We'll just ignore old dirt saves for stability since they were broken anyway.
    } else {
        for (var i = 0; i < _count; i++) {
            var _key = "Dirt_" + string(i);
            array_push(farm_dirt_data, {
                _x: ini_read_real(_key, "x", 0),
                _y: ini_read_real(_key, "y", 0),
                _state: ini_read_real(_key, "state", 0),
                _is_watered: ini_read_real(_key, "is_watered", 0),
                _is_fertilized: ini_read_real(_key, "is_fertilized", 0),
                _is_infected: ini_read_real(_key, "is_infected", 0),
                _has_weed: ini_read_real(_key, "has_weed", 0),
                _is_neglected: ini_read_real(_key, "is_neglected", 0),
                _plant_stage: ini_read_real(_key, "plant_stage", 0),
                _plant_type: ini_read_real(_key, "plant_type", -1),
                _growth_timer: ini_read_real(_key, "growth_timer", 0),
                _rot_timer: ini_read_real(_key, "rot_timer", 0)
            });
        }
    }
    
    // Nếu vô tình load ngay tại rm_farm, tạo obj_dirt luôn
    if (room == rm_farm) {
        with (obj_dirt) instance_destroy();
        for (var i = 0; i < array_length(farm_dirt_data); i++) {
            var _d = farm_dirt_data[i];
            var _inst = instance_create_layer(_d._x, _d._y, "Instances", obj_dirt);
            _inst.state = _d._state;
            _inst.is_watered = _d._is_watered;
            _inst.is_fertilized = _d._is_fertilized;
            _inst.is_infected = _d._is_infected;
            _inst.has_weed = _d._has_weed;
            _inst.is_neglected = _d._is_neglected;
            _inst.plant_stage = _d._plant_stage;
            _inst.plant_type = _d._plant_type;
            _inst.growth_timer = _d._growth_timer;
            _inst.rot_timer = _d._rot_timer;
        }
    }

    ini_close();
}


}