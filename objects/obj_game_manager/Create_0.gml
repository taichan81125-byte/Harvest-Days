// Biến kiểm tra xem hộp thoại có đang mở không (mặc định là tắt)
show_dialogue = false;

// Nội dung bức thư của Bác Mộc đã có Tiếng Việt
dialogue_text = "Chào cháu, người bạn trẻ!\nKhu vườn này đang ngủ say, ta tin cháu có thể đánh thức nó.\nHãy lấy các dụng cụ trên chiếc bàn bên cạnh để bắt đầu công việc nhé.\nChúc cháu may mắn với Ngày Thu Hoạch!";

// Biến bật/tắt UI cửa hàng
show_shop = false;

// Biến đếm ngày và thời tiết
day_count = 1;
is_raining = false;

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
if (room == rm_farm) {
if (!audio_is_playing(snd_bgm)) {
audio_play_sound(snd_bgm, 0, true);
}
}

// ========================================================
// KHO DỮ LIỆU VẬT PHẨM (ID từ 0 đến 11)
// ========================================================
item_names = ["Cuốc", "Bình Tưới", "Hạt Cà Chua", "Hạt Ngô", "Ghế Gỗ", "Chậu Hoa", "Đèn Lồng", "Cà Chua (Thường)", "Phân Bón", "Thuốc Sinh Học", "Cái Liềm", "Cà Chua (Hạng A)"];
item_prices = [0, 0, 5, 10, 50, 30, 100, 5, 8, 12, 15, 25];
item_sprites = [spr_icon_hoe, spr_icon_water, spr_icon_tomato, spr_icon_corn, spr_icon_chair, spr_icon_pot, spr_icon_lantern, spr_crop_tomato, spr_icon_fertilizer, spr_icon_pesticide, spr_icon_sickle, spr_crop_tomato_a];

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

ini_close();


}

function load_game(_file_name) {
if (_file_name == undefined) _file_name = "harvest_save_default.ini";

if (file_exists(_file_name)) {
    ini_open(_file_name);

    owner_name = ini_read_string("Info", "owner_name", "Người chơi mới");
    obj_player.coins = ini_read_real("Player", "coins", 50);
    obj_player.hunger = ini_read_real("Player", "hunger", 100);
    obj_player.hp = ini_read_real("Player", "hp", 3);

    for(var i = 0; i < 10; i++) {
        obj_player.inventory[i] = ini_read_real("Inventory", "item_" + string(i), -1);
        obj_player.inventory_count[i] = ini_read_real("Inventory", "count_" + string(i), 0);
    }

    day_count = ini_read_real("Game", "day_count", 1);

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

    ini_close();
}


}