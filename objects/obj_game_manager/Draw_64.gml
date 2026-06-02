draw_set_font(fnt_vietnamese);

// ==========================================
// HIỆU ỨNG ÁNH SÁNG NGÀY/ĐÊM (VẼ TRƯỚC TIÊN ĐỂ KHÔNG ĐÈ LÊN UI)
// ==========================================
if ((room == rm_farm || room == rm_house) && day_overlay_alpha > 0) {
    draw_set_color(day_overlay_color);
    draw_set_alpha(day_overlay_alpha);
    // Hardcode kích thước GUI là 1280x720 cho chắc chắn
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
}
if (instance_exists(obj_player)) {
draw_set_color(c_yellow);
draw_text(20, 20, "Tiền (Coins): " + string(obj_player.coins));

if (room == rm_farm || room == rm_house) {
    // Kéo các UI như tim và thức ăn sang trái một chút (về tọa độ 950) để nhường chỗ cho Đồng hồ
    var _ui_right_x = 950; 
    
    for (var i = 0; i < 3; i++) {
        if (i < obj_player.hp) draw_sprite(spr_heart_full, 0, _ui_right_x + (i * 36), 20); 
        else draw_sprite(spr_heart_empty, 0, _ui_right_x + (i * 36), 20); 
    }
    
    var _bar_y = 65;
    draw_set_color(c_dkgray); draw_rectangle(_ui_right_x, _bar_y, _ui_right_x + 100, _bar_y + 15, false); 
    draw_set_color(c_orange); draw_rectangle(_ui_right_x, _bar_y, _ui_right_x + obj_player.hunger, _bar_y + 15, false); 
    draw_set_color(c_white); draw_rectangle(_ui_right_x, _bar_y, _ui_right_x + 100, _bar_y + 15, true); 

    draw_sprite_ext(spr_icon_gear, 0, 1155, -19, 0.33, 0.33, 0, c_white, 1);

    // ==========================================
    // VẼ ĐỒNG HỒ VÀ NGÀY
    // ==========================================
    var _clock_str = string(game_hour) + ":" + (game_minute < 10 ? "0" : "") + string(game_minute);
    
    // Đặt đồng hồ ở giữa trái tim (1022) và nút cài đặt (1180), nên _cx tầm 1130
    var _cx = 1130;
    var _cy = 50;
    var _clock_scale = 160 / 450; // Cho đồng hồ to hơn (đường kính tầm 160px)
    
    draw_sprite_ext(spr_mat_dong_ho, 0, _cx, _cy, _clock_scale, _clock_scale, 0, c_white, 1);
    
    var _time_decimal = game_hour + (game_minute / 60);
    // Đồng hồ quay thuận chiều kim (12h/vòng):
    // 00h/12h -> Góc 0 (Chỉ lên trên)
    // 03h/15h -> Góc -90 (Chỉ sang phải)
    // 06h/18h -> Góc -180 (Chỉ xuống dưới)
    // 09h/21h -> Góc 90 (Chỉ sang trái)
    var _angle = -(_time_decimal * 30);
    
    draw_sprite_ext(spr_kim_dong_ho, 0, _cx, _cy, _clock_scale, _clock_scale, _angle, c_white, 1);

    // Text Ngày và Giờ (Cắt xa nhau ra một chút)
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text(_cx, _cy + 45, "Ngày " + string(day_count));
    draw_set_color(c_yellow);
    draw_text(_cx, _cy + 75, _clock_str);
    draw_set_halign(fa_left);
    var _start_x = 340; var _y = 650;       
    
    for(var j = 0; j < 10; j++) {
        var _slot_x = _start_x + (j * 60);
        if (obj_player.selected_slot == j) { draw_set_color(c_yellow); draw_rectangle(_slot_x - 3, _y - 3, _slot_x + 53, _y + 53, false); }
        draw_set_color(c_dkgray); draw_rectangle(_slot_x, _y, _slot_x + 50, _y + 50, false);
        draw_set_color(c_white); draw_rectangle(_slot_x, _y, _slot_x + 50, _y + 50, true);
        
        var _item_id = obj_player.inventory[j];
        if (_item_id != -1) {
            var _spr = item_sprites[_item_id];
            draw_sprite_stretched(_spr, 0, _slot_x + 5, _y + 5, 40, 40);
            
            var _count = obj_player.inventory_count[j];
            if (_count > 1) {
                draw_set_color(c_white); draw_set_halign(fa_right); draw_text(_slot_x + 48, _y + 30, string(_count)); draw_set_halign(fa_left);
            }
        }
        draw_set_color(c_yellow); if (j == 9) draw_text(_slot_x + 5, _y - 25, "0"); else draw_text(_slot_x + 5, _y - 25, string(j + 1));
    }
    
    if (obj_player.item_popup_timer > 0 && obj_player.selected_slot != -1) {
        var _current_item = obj_player.inventory[obj_player.selected_slot];
        if (_current_item != -1) {
            var _item_name = item_names[_current_item]; var _alpha = 1.0;
            if (obj_player.item_popup_timer < 30) _alpha = obj_player.item_popup_timer / 30;
            draw_set_alpha(_alpha); draw_set_halign(fa_center); draw_set_color(c_white); draw_text(640, 590, _item_name); draw_set_halign(fa_left); draw_set_alpha(1.0);
        }
    }
} 


}

// =========================================================
// MỤC MỚI: VẼ MENU TẠM DỪNG VÀ CÀI ĐẶT
// =========================================================
if (is_paused == true) {
draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(0, 0, 1280, 720, false); draw_set_alpha(1.0);
draw_set_halign(fa_center);

// NẾU ĐANG Ở MENU PAUSE THƯỜNG
if (show_settings == false) {
    draw_set_color(c_yellow); draw_text_transformed(640, 100, "TẠM DỪNG", 2, 2, 0);
    var _btn_w = 300; var _btn_h = 60; var _btn_x = 640 - (_btn_w / 2);
    var _btn_texts = ["Tiếp Tục", "Cài Đặt", "Thoát Về Menu"];
    
    for(var i = 0; i < 3; i++) {
        var _btn_y = 250 + (i * 120);
        draw_set_color(c_dkgray); draw_rectangle(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, false);
        draw_set_color(c_white); draw_rectangle(_btn_x, _btn_y, _btn_x + _btn_w, _btn_y + _btn_h, true);
        draw_text(_btn_x + (_btn_w / 2), _btn_y + 15, _btn_texts[i]);
    }
}
// NẾU ĐANG BẬT BẢNG CÀI ĐẶT
else {
    draw_set_color(c_yellow); draw_text_transformed(640, 100, "CÀI ĐẶT ÂM THANH", 2, 2, 0);
    
    // Vẽ chữ hiển thị % âm lượng
    draw_set_color(c_white);
    var _vol_percent = floor(global.master_vol * 100);
    if (global.is_muted == true) draw_text_transformed(640, 220, "Âm lượng: TẮT", 1.5, 1.5, 0);
    else draw_text_transformed(640, 220, "Âm lượng: " + string(_vol_percent) + "%", 1.5, 1.5, 0);
    
    // Vẽ nút [-]
    draw_set_color(c_dkgray); draw_rectangle(450, 300, 500, 350, false);
    draw_set_color(c_white); draw_rectangle(450, 300, 500, 350, true); draw_text(475, 310, "-");
    
    // Vẽ thanh mô phỏng âm lượng ở giữa
    draw_rectangle(520, 310, 760, 340, true);
    draw_set_color(c_lime); draw_rectangle(522, 312, 522 + (236 * global.master_vol), 338, false);
    
    // Vẽ nút [+]
    draw_set_color(c_dkgray); draw_rectangle(780, 300, 830, 350, false);
    draw_set_color(c_white); draw_rectangle(780, 300, 830, 350, true); draw_text(805, 310, "+");
    
    // Vẽ nút TẮT/BẬT TIẾNG
    var _mute_text = (global.is_muted == true) ? "Bật Tiếng" : "Tắt Tiếng";
    draw_set_color(c_dkgray); draw_rectangle(540, 400, 740, 450, false);
    draw_set_color(c_white); draw_rectangle(540, 400, 740, 450, true); draw_text(640, 410, _mute_text);
    
    // Vẽ nút TRỞ VỀ
    draw_set_color(c_dkgray); draw_rectangle(540, 500, 740, 550, false);
    draw_set_color(c_red); draw_rectangle(540, 500, 740, 550, true); draw_text(640, 510, "Trở Về");
}
draw_set_halign(fa_left); 


}

// CÁC UI CŨ BÊN DƯỚI GIỮ NGUYÊN (Hộp thoại, Cửa hàng...)
if (show_dialogue == true && is_paused == false) {
draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(50, 500, 1230, 680, false);
draw_set_alpha(1.0); draw_set_color(c_white); draw_rectangle(50, 500, 1230, 680, true);
draw_text_ext(70, 520, dialogue_text, 30, 1100);
draw_set_color(c_yellow); draw_text(1000, 640, "[Nhấn SPACE để đóng]");
}

if (show_shop == true && is_paused == false) {
draw_set_color(c_black); draw_set_alpha(0.8); draw_rectangle(200, 100, 1080, 600, false);
draw_set_alpha(1.0); draw_set_color(c_white); draw_rectangle(200, 100, 1080, 600, true);
draw_text(450, 130, "--- CỬA HÀNG HÔM NAY ---");

var _start_x = 250; var _btn_y = 250;
for(var i = 0; i < 5; i++) {
    var _item_id = daily_shop[i];
    var _btn_x = _start_x + (i * 150); 
    
    draw_set_color(c_dkgray); draw_rectangle(_btn_x, _btn_y, _btn_x + 100, _btn_y + 100, false);
    draw_set_color(c_white); draw_rectangle(_btn_x, _btn_y, _btn_x + 100, _btn_y + 100, true);
    
    if (_item_id != -1) {
        var _price = item_prices[_item_id]; var _spr = item_sprites[_item_id]; 
        draw_sprite_stretched(_spr, 0, _btn_x + 18, _btn_y + 18, 64, 64);
        if (_item_id == 2 || _item_id == 3) {
            draw_set_color(c_yellow); draw_set_halign(fa_right); draw_text(_btn_x + 95, _btn_y + 75, "x5"); draw_set_halign(fa_left); draw_set_color(c_white);
        }
        draw_text(_btn_x + 10, _btn_y + 110, string(_price) + " Vàng");
    } else {
        draw_set_color(c_gray); draw_text(_btn_x + 15, _btn_y + 40, "Đã Bán"); draw_set_color(c_white);
    }
}
draw_set_color(c_yellow); draw_text(450, 550, "[Nhấn SPACE để đóng]");


}