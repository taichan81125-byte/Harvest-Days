if (is_raining == true) {
effect_create_above(ef_rain, 0, 0, 1, c_silver);
}

// BẤM ESC ĐỂ BẬT/TẮT PAUSE
if (keyboard_check_pressed(vk_escape)) {
if (is_paused == false) {
is_paused = true;
show_shop = false;

show_dialogue = false;

show_settings = false; // Đảm bảo bảng Cài đặt tắt khi mới Pause
}
else {
is_paused = false;
show_settings = false;
}
}

// CLICK CHUỘT TRÊN GIAO DIỆN
if (mouse_check_button_pressed(mb_left)) {
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// 1. CLICK ICON BÁNH RĂNG (MỞ PAUSE)
if (is_paused == false && _mx > 1180 && _mx < 1244 && _my > 20 && _my < 84) {
    is_paused = true;
    show_shop = false;
    show_dialogue = false;
}

// 2. CLICK TRONG MENU TẠM DỪNG (KHI CHƯA MỞ CÀI ĐẶT)
if (is_paused == true && show_settings == false) {
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
        room_goto(rm_menu); 
    }
}

// 3. CLICK TRONG BẢNG CÀI ĐẶT ÂM THANH
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