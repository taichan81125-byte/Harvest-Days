// ========================================================
// BƯỚC ĐỆM LOAD GAME LÚC VỪA VÀO PHÒNG (SAU KHI CHỌN SLOT)
// ========================================================

// Chỉ chạy logic load/init khi vào rm_farm hoặc rm_city
if (room != rm_farm && room != rm_city) exit;

// ==========================================
// XỬ LÝ TELEPORT GIỮA FARM VÀ CITY (TỰ ĐỘNG TÌM CỬA)
// ==========================================
if (variable_global_exists("target_door") && global.target_door != "") {
    if (global.target_door == "from_farm" && room == rm_city) {
        if (instance_exists(obj_to_farm)) {
            // Map City nằm bên trái Farm, nên cổng về Farm nằm ở bên Phải bản đồ City.
            // Bắn nhân vật ra KHỎI vùng kích hoạt, sang bên Trái của cổng (bbox_left - 32)
            obj_player.x = obj_to_farm.bbox_left - 32; 
            // KHÔNG đổi Y, để nhân vật đi đúng cao độ đường
        }
    } else if (global.target_door == "from_city" && room == rm_farm) {
        if (instance_exists(obj_to_city)) {
            // Map Farm nằm bên phải City, nên cổng về City nằm ở bên Trái bản đồ Farm.
            // Bắn nhân vật ra KHỎI vùng kích hoạt, sang bên Phải của cổng (bbox_right + 32)
            obj_player.x = obj_to_city.bbox_right + 32; 
            // KHÔNG đổi Y, để nhân vật đi đúng cao độ đường
        }
    }
    global.target_door = ""; // Reset
}

// Ẩn Tile layer cũ (Tiles_1) nếu có để lộ phần hình nền đã được vẽ
// Đặt đoạn này TRƯỚC khi exit vì mỗi khi quay lại room nó sẽ bị hiện lại
if (room == rm_farm || room == rm_city) {
    var _layer_id = layer_get_id("Tiles_1");
    if (_layer_id != -1) layer_set_visible(_layer_id, false);
    var _layer_id_3 = layer_get_id("Tiles_3");
    if (_layer_id_3 != -1) layer_set_visible(_layer_id_3, false);
    var _layer_id_2 = layer_get_id("Tiles_2");
    if (_layer_id_2 != -1) layer_set_visible(_layer_id_2, false);
}

// Tránh chạy lại khi quay về rm_farm từ rm_house (persistent object)
if (variable_instance_exists(id, "game_initialized") && game_initialized == true) exit;
game_initialized = true;

// LỚP BẢO VỆ: Nếu test game chạy thẳng vào rm_farm mà chưa qua Menu
if (!variable_global_exists("is_new_game")) {
    global.is_new_game = true;
    global.player_name = "Test_Farm";
    global.current_save_file = "slot1.ini";
}

if (global.is_new_game == true) {
    // Trường hợp 1: Người chơi bấm vào Slot Trống và vừa gõ tên xong
    owner_name = global.player_name;
    day_count = 1; // Luôn bắt đầu từ Ngày 1
    current_season = 0; // Mùa Hạ (đã remap)
    show_debug_message("Bắt đầu Game Mới với tài khoản: " + owner_name);
} 
else {
    // Trường hợp 2: Người chơi bấm vào Slot đã có tên (Chơi tiếp)
    load_game(global.current_save_file);
}

// Cập nhật lại tốc độ thời gian cho đúng với từng save slot
frames_per_game_minute = (global.current_save_file == "slot4.ini") ? 2 : 5;

// Khôi phục đất cuốc khi vào lại rm_farm
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
