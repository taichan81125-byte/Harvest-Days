// Tránh tạo bản sao khi quay lại phòng có game_manager trong Room Editor
if (instance_number(obj_game_manager) > 1) {
    instance_destroy();
    exit;
}

// Đổi con trỏ chuột sang sprite mới và ẩn con trỏ chuột hệ thống
cursor_sprite = spr_mouse;
window_set_cursor(cr_none);

// Biến kiểm tra xem hộp thoại có đang mở không (mặc định là tắt)
show_dialogue = false;

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
frames_per_game_minute = 5; // 5 frames = 1 phút game (300 frames = 1 giờ @ 60fps)

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

function advance_time(_hours) {
    game_hour += _hours;
    var _days_passed = 0;
    while (game_hour >= 24) {
        game_hour -= 24;
        _days_passed += 1;
    }
    
    if (_days_passed > 0) {
        day_count += _days_passed;
        reset_shop();
        
        var _rain_chance = irandom(99); 
        if (_rain_chance < 30) is_raining = true; else is_raining = false;
        
        with (obj_dirt) {
            if (obj_game_manager.is_raining == true) {
                is_watered = true;
            } else {
                // Chỉ làm khô đất nếu chưa trồng cây
                if (plant_stage == 0) is_watered = false; 
            }
            
            // Sâu bệnh ĐÃ ĐƯỢC CHUYỂN XUỐNG CUỐI HÀM để không bị cộng dồn thời gian ngủ
            
            // Quả chín để qua đêm sẽ héo úa
            if (plant_stage == 3) {
                plant_stage = 4; // Hỏng luôn
                effect_create_above(ef_smoke, x + 32, y + 32, 1, c_dkgray);
            }
        }
    }
    
    // Đổ xúc xắc mọc cỏ dại cho mỗi giờ trôi qua
    for (var i = 0; i < floor(_hours); i++) {
        with (obj_dirt) {
            if (state == 1 && has_weed == false) {
                if (irandom(100) < 2) has_weed = true;
            }
        }
    }
    
    // Tự động cho cây trồng lớn lên tương ứng với số thời gian bỏ qua
    var _frames_passed = _hours * 60 * frames_per_game_minute;
    with (obj_dirt) {
        if (plant_stage > 0 && plant_stage < 3) {
            // Cỏ dại không làm ngừng lớn, nhưng sâu bệnh thì CÓ
            if (is_watered == true && is_infected == false) {
                growth_timer += _frames_passed;
                while (growth_timer >= growth_max && plant_stage < 3) {
                    plant_stage += 1;
                    growth_timer -= growth_max;
                    rot_timer = 0;
                    
                    if (obj_game_manager.is_raining) {
                        is_watered = true;
                    } else {
                        is_watered = false;
                        growth_timer = 0; // Dừng lại vì hết nước cho giai đoạn sau
                        break;
                    }
                }
            } 
            
            if (is_infected == true) {
                is_neglected = true;
                rot_timer += _frames_passed;
                if (rot_timer >= 3600) { // 12 tiếng để xịt thuốc
                    plant_stage = 4;
                }
            }
            
            if (has_weed == true) {
                is_neglected = true;
            }
        } 
        // Đã xóa phần thối hỏng ở Giai đoạn 3 (khi có quả) vì đã xử lý ở trên (qua ngày)
    }
    
    // Sâu bệnh chỉ sinh ra lúc 6h sáng (qua đêm)
    // Thực hiện SAU KHI đã cộng thời gian để sâu mới sinh không bị chết ngay lập tức
    if (_days_passed > 0) {
        with (obj_dirt) {
            if (plant_stage > 0 && plant_stage < 3) {
                if (irandom(100) < 20) is_infected = true;
            }
        }
    }
}

// TÍNH NĂNG MỚI: MENU TẠM DỪNG VÀ CÀI ĐẶT
is_paused = false;
show_settings = false; // Bật/tắt bảng Cài đặt

// ==========================================
// HỆ THỐNG ÂM THANH TOÀN CỤC (GLOBAL AUDIO)
// ==========================================
if (!variable_global_exists("master_vol")) {
global.master_vol = 1.0;  // Âm lượng từ 0.0 đến 1.0 (100%)
global.is_muted = false;  // Trạng thái Tắt tiếng
audio_master_gain(global.master_vol);
}

// Bật nhạc nền lặp đi lặp lại (Loop) khi vào phòng Nông trại
if (room == rm_farm || room == rm_house) {
if (!audio_is_playing(snd_bgm)) {
audio_play_sound(snd_bgm, 0, true);
}
}

// ========================================================
// KHO DỮ LIỆU VẬT PHẨM (ID từ 0 đến 12)
// ========================================================
item_names = ["Cuốc", "Bình Tưới", "Hạt Cà Chua", "Hạt Ngô", "Ghế Gỗ", "Chậu Hoa", "Đèn Lồng", "Cà Chua (Thường)", "Phân Bón", "Thuốc Sinh Học", "Cái Liềm", "Cà Chua (Hạng A)", "Cà Chua (Hạng B)"];
item_prices = [0, 0, 5, 10, 50, 30, 100, 5, 8, 12, 15, 25, 2]; // Hạng B bán được thấp tiền nhất (2 xu)
item_sprites = [spr_icon_hoe, spr_icon_water, spr_icon_tomato, spr_icon_corn, spr_icon_chair, spr_icon_pot, spr_icon_lantern, spr_crop_tomato, spr_icon_fertilizer, spr_icon_pesticide, spr_icon_sickle, spr_crop_tomato_a, spr_crop_tomato_b];

daily_shop = [0, 0, 0, 0, 0];

function reset_shop() {
for(var i = 0; i < 5; i++) {
daily_shop[i] = choose(2, 3, 4, 5, 6, 8, 9, 10);
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

ini_write_real("Game", "day_count", day_count);
ini_write_real("Game", "game_hour", game_hour);
ini_write_real("Game", "game_minute", game_minute);

// Chỉ lưu dữ liệu đất khi ở nông trại (obj_dirt chỉ tồn tại ở rm_farm)
if (room == rm_farm) {
    with (obj_dirt) {
        var _key = "Dirt_" + string(x) + "_" + string(y);
        ini_write_real(_key, "state", state);
        ini_write_real(_key, "is_watered", is_watered);
        ini_write_real(_key, "is_fertilized", is_fertilized);
        ini_write_real(_key, "is_infected", is_infected);
        ini_write_real(_key, "has_weed", has_weed);
        ini_write_real(_key, "is_neglected", is_neglected);
        ini_write_real(_key, "plant_stage", plant_stage);
        ini_write_real(_key, "plant_type", plant_type);
        ini_write_real(_key, "growth_timer", growth_timer);
        ini_write_real(_key, "rot_timer", rot_timer);
    }
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

    day_count = ini_read_real("Game", "day_count", 1);
    game_hour = ini_read_real("Game", "game_hour", 6);
    game_minute = ini_read_real("Game", "game_minute", 0);

    // Chỉ tải dữ liệu đất khi ở nông trại
    if (room == rm_farm) {
        with (obj_dirt) {
            var _key = "Dirt_" + string(x) + "_" + string(y);
            state = ini_read_real(_key, "state", 0);
            is_watered = ini_read_real(_key, "is_watered", 0);
            is_fertilized = ini_read_real(_key, "is_fertilized", 0);
            is_infected = ini_read_real(_key, "is_infected", 0);
            has_weed = ini_read_real(_key, "has_weed", 0);
            is_neglected = ini_read_real(_key, "is_neglected", 0);
            plant_stage = ini_read_real(_key, "plant_stage", 0);
            plant_type = ini_read_real(_key, "plant_type", -1);
            growth_timer = ini_read_real(_key, "growth_timer", 0);
            rot_timer = ini_read_real(_key, "rot_timer", 0);
        }
    }

    ini_close();
}


}