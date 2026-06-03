import os
import json
import uuid

def add_event(obj_name, event_type, event_num, code_content):
    obj_dir = os.path.join("objects", obj_name)
    yy_path = os.path.join(obj_dir, f"{obj_name}.yy")
    
    if event_type == "Create":
        ev_type = 0
    elif event_type == "Step":
        ev_type = 3
    elif event_type == "Draw":
        ev_type = 8
    
    # Save the gml file
    gml_name = f"{event_type}_{event_num}.gml"
    gml_path = os.path.join(obj_dir, gml_name)
    with open(gml_path, 'w', encoding='utf-8') as f:
        f.write(code_content)
        
    # Update the .yy file
    with open(yy_path, 'r', encoding='utf-8') as f:
        yy_data = json.load(f)
        
    # Check if event already exists
    exists = False
    for ev in yy_data.get("eventList", []):
        if ev["eventNum"] == event_num and ev["eventType"] == ev_type:
            exists = True
            break
            
    if not exists:
        yy_data["eventList"].append({
            "$GMEvent": "v1",
            "%Name": "",
            "collisionObjectId": None,
            "eventNum": event_num,
            "eventType": ev_type,
            "isDnD": False,
            "name": "",
            "resourceType": "GMEvent",
            "resourceVersion": "2.0"
        })
        with open(yy_path, 'w', encoding='utf-8') as f:
            json.dump(yy_data, f, indent=2)

# --- obj_ui_load_slot ---
slot_create = """
slot_files = ["slot1.ini", "slot2.ini", "slot3.ini", "slot4.ini"];
file_name = slot_files[slot_index];

player_name = "Trống";
day_count = 0;

if (file_exists(file_name)) {
    ini_open(file_name);
    player_name = ini_read_string("Info", "owner_name", "Nong Dan");
    day_count = ini_read_real("Game", "day_count", 1);
    ini_close();
}

if (slot_index == 3) {
    player_name = "Admin_farm";
}

is_typing = false;
new_name = "";
"""

slot_step = """
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
"""

slot_draw = """
draw_set_font(fnt_vietnamese);

var _draw_x = bbox_left;
var _draw_y = bbox_top;

var _is_hover = position_meeting(mouse_x, mouse_y, id);

if (_is_hover) {
    draw_set_alpha(0.1);
    draw_set_color(c_white);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1.0);
}

if (is_typing) {
    draw_set_color(c_yellow);
    draw_text(_draw_x + 30, _draw_y + 25, "Nhập tên: " + new_name + "_farm_");
    
    draw_set_alpha(abs(sin(current_time/200)));
    draw_set_color(c_white);
    draw_text(_draw_x + 30, _draw_y + 60, "[Nhấn ENTER để xác nhận | ESC để hủy]");
    draw_set_alpha(1.0);
} else {
    if (player_name == "Trống") {
        draw_set_color(make_color_rgb(150, 150, 150));
        draw_set_halign(fa_center);
        draw_text(_draw_x + (bbox_right - bbox_left)/2, _draw_y + (bbox_bottom - bbox_top)/2 - 15, "+ TẠO MỚI +");
        draw_set_halign(fa_left);
    } else {
        draw_set_color(make_color_rgb(60, 180, 80));
        draw_circle(_draw_x + 50, _draw_y + 50, 30, false);
        draw_set_color(c_white);
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(_draw_x + 50, _draw_y + 50, string_char_at(player_name, 1));
        draw_set_halign(fa_left); draw_set_valign(fa_top);
        
        draw_set_color(make_color_rgb(0, 255, 150));
        draw_text(_draw_x + 100, _draw_y + 20, "Nông Trại: " + player_name);
        
        draw_set_color(make_color_rgb(200, 200, 200));
        draw_text(_draw_x + 100, _draw_y + 60, "Đã cày cuốc: " + string(day_count) + " ngày");
    }
}
"""

# --- obj_ui_delete_btn ---
del_step = """
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
"""

del_draw = """
var _is_hover = position_meeting(mouse_x, mouse_y, id);

if (_is_hover) {
    draw_set_alpha(0.3);
    draw_set_color(c_red);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1.0);
}
"""

# --- obj_ui_back_btn ---
back_step = """
if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        room_goto(rm_menu);
    }
}
"""

back_draw = """
var _is_hover = position_meeting(mouse_x, mouse_y, id);

if (_is_hover) {
    draw_set_alpha(0.3);
    draw_set_color(make_color_rgb(220, 50, 50));
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1.0);
}
"""

add_event("obj_ui_load_slot", "Create", 0, slot_create)
add_event("obj_ui_load_slot", "Step", 0, slot_step)
add_event("obj_ui_load_slot", "Draw", 0, slot_draw)

add_event("obj_ui_delete_btn", "Step", 0, del_step)
add_event("obj_ui_delete_btn", "Draw", 0, del_draw)

add_event("obj_ui_back_btn", "Step", 0, back_step)
add_event("obj_ui_back_btn", "Draw", 0, back_draw)

print("Events added successfully.")
