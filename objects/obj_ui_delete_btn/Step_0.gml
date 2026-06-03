if (!variable_instance_exists(id, "initialized")) {
    var _count = 0;
    with (obj_ui_delete_btn) {
        if (y < other.y) _count++;
    }
    slot_index = _count;
    initialized = true;
}

if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        var _slot_files = ["slot1.ini", "slot2.ini", "slot3.ini", "slot4.ini"];
        var _file = _slot_files[slot_index];
        if (file_exists(_file) && slot_index != 3) {
            file_delete(_file);
            with(obj_ui_load_slot) {
                if (slot_index == other.slot_index) {
                    player_name = "Trống";
                    day_count = 0;
                }
            }
        }
    }
}
