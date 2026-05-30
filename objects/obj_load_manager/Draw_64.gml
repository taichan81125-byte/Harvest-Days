draw_set_font(fnt_vietnamese);

// VẼ TIÊU ĐỀ
draw_set_halign(fa_center);
draw_set_color(c_yellow);
draw_text_transformed(640, 50, "CHỌN HỒ SƠ LƯU TRỮ", 2, 2, 0);
draw_set_halign(fa_left);

var _start_x = 340;
var _start_y = 150;

// VẼ 4 SLOT LƯU GAME
for(var i = 0; i < 4; i++) {
    var _btn_y = _start_y + (i * 120);
    
    // Nền Slot
    draw_set_color(c_dkgray);
    draw_rectangle(_start_x, _btn_y, _start_x + 600, _btn_y + 100, false);
    draw_set_color(c_white);
    draw_rectangle(_start_x, _btn_y, _start_x + 600, _btn_y + 100, true);

    // TRƯỜNG HỢP 1: SLOT NÀY ĐANG ĐƯỢC CHỌN ĐỂ GÕ TÊN
    if (is_typing == true && typing_slot == i) {
        draw_set_color(c_yellow);
        // Hiển thị tên gõ vào kèm hậu tố _farm luôn cho người chơi thấy
        draw_text(_start_x + 20, _btn_y + 30, "Nhập tên: " + new_name + "_farm_");
        draw_text(_start_x + 20, _btn_y + 60, "[Nhấn ENTER để xác nhận]");
    } 
    // TRƯỜNG HỢP 2: SLOT BÌNH THƯỜNG
    else {
        if (slot_names[i] == "Trống") {
            draw_set_color(c_gray);
            draw_text(_start_x + 250, _btn_y + 35, "< Trống >");
        } else {
            // In tên chủ nông trại màu Xanh Lá
            draw_set_color(c_lime);
            draw_text(_start_x + 20, _btn_y + 20, "Chủ Nông Trại: " + slot_names[i]);
            // In số ngày
            draw_set_color(c_white);
            draw_text(_start_x + 20, _btn_y + 60, "Đã chơi: " + string(slot_days[i]) + " ngày");
            
            // Vẽ Nút XÓA (Màu Đỏ bên phải)
            draw_set_color(c_red);
            draw_rectangle(_start_x + 500, _btn_y + 25, _start_x + 580, _btn_y + 75, false);
            draw_set_color(c_white);
            draw_text(_start_x + 518, _btn_y + 40, "XÓA");
        }
    }
}

// VẼ NÚT TRỞ VỀ MENU
draw_set_color(c_red);
draw_rectangle(20, 20, 150, 70, false);
draw_set_color(c_white);
draw_text(40, 35, "< TRỞ VỀ");