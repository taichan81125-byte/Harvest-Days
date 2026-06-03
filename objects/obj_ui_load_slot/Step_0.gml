if (!initialized) {
    var _count = 0;
    with (obj_ui_load_slot) {
        if (y < other.y) _count++;
    }
    slot_index = _count;
    file_name = slot_files[slot_index];
    
    if (file_exists(file_name)) {
        ini_open(file_name);
        player_name = ini_read_string("Info", "owner_name", "Nong Dan");
        day_count = ini_read_real("Game", "day_count", 1);
        ini_close();
    }
    if (slot_index == 3) {
        player_name = "Admin_farm";
    }
    initialized = true;
}

if (is_typing) {
    new_name = keyboard_string;
    if (string_length(new_name) > 12) {
        new_name = string_copy(new_name, 1, 12);
        keyboard_string = new_name;
    }
    
    if (keyboard_check_pressed(vk_enter) && new_name != "") {
        global.current_save_file = file_name;
        global.player_name = new_name + "_farm";
        global.is_new_game = true;
        room_goto(rm_farm);
    }
    
    if (keyboard_check_pressed(vk_escape)) {
        is_typing = false;
    }
    exit;
}

if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        if (player_name == "Trống") {
            with (obj_ui_load_slot) { is_typing = false; }
            is_typing = true;
            keyboard_string = "";
            new_name = "";
        } else {
            global.current_save_file = file_name;
            global.player_name = player_name;
            global.is_new_game = false;
            if (slot_index == 3 && !file_exists(file_name)) {
                global.is_new_game = true;
            }
            room_goto(rm_farm);
        }
    }
}
