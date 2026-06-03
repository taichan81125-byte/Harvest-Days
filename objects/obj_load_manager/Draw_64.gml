// draw_set_font(fnt_vietnamese);

// var _mx = device_mouse_x_to_gui(0);
// var _my = device_mouse_y_to_gui(0);

// // Nền Gradient tinh tế
// draw_rectangle_color(0, 0, 1280, 720, c_black, c_black, make_color_rgb(10, 20, 40), make_color_rgb(10, 20, 40), false);

// // VẼ TIÊU ĐỀ CÓ BÓNG ĐỔ
// draw_set_halign(fa_center);
// var _title = "CHỌN HỒ SƠ LƯU TRỮ";
// draw_set_color(c_black); draw_set_alpha(0.5);
// draw_text_transformed(644, 44, _title, 2, 2, 0);
// draw_set_alpha(1.0); draw_set_color(make_color_rgb(255, 215, 0)); // Vàng Gold
// draw_text_transformed(640, 40, _title, 2, 2, 0);
// draw_set_halign(fa_left);

// var _start_x = 340;
// var _start_y = 150;

// // VẼ NÚT TRỞ VỀ MENU VỚI HOVER
// var _btn_back_hover = (_mx > 30 && _mx < 180 && _my > 30 && _my < 80);
// draw_set_alpha(_btn_back_hover ? 1.0 : 0.8);
// draw_set_color(make_color_rgb(220, 50, 50));
// draw_rectangle(30, 30, 180, 80, false);
// draw_set_color(c_white);
// draw_text(60, 45, "< TRỞ VỀ");
// draw_set_alpha(1.0);

// // VẼ 4 SLOT LƯU GAME
// for(var i = 0; i < 4; i++) {
//     var _btn_y = _start_y + (i * 120);
//     var _is_hover = (_mx > _start_x && _mx < _start_x + 600 && _my > _btn_y && _my < _btn_y + 100);
    
//     // Nền Slot Glassmorphism
//     draw_set_alpha(0.6);
//     draw_set_color(make_color_rgb(30, 35, 50));
//     draw_rectangle(_start_x, _btn_y, _start_x + 600, _btn_y + 100, false);
//     draw_set_alpha(1.0);
    
//     // Viền Slot (Sáng lên nếu Hover)
//     draw_set_color(_is_hover ? make_color_rgb(0, 255, 255) : make_color_rgb(100, 110, 130));
//     draw_rectangle(_start_x, _btn_y, _start_x + 600, _btn_y + 100, true);

//     // TRƯỜNG HỢP 1: SLOT NÀY ĐANG ĐƯỢC CHỌN ĐỂ GÕ TÊN
//     if (is_typing == true && typing_slot == i) {
//         draw_set_color(c_yellow);
//         draw_text(_start_x + 30, _btn_y + 25, "Nhập tên: " + new_name + "_farm_");
        
//         // Chữ nhấp nháy cho Enter
//         draw_set_alpha(abs(sin(current_time/200)));
//         draw_set_color(c_white);
//         draw_text(_start_x + 30, _btn_y + 60, "[Nhấn ENTER để xác nhận | ESC để hủy]");
//         draw_set_alpha(1.0);
//     } 
//     // TRƯỜNG HỢP 2: SLOT BÌNH THƯỜNG
//     else {
//         if (slot_names[i] == "Trống") {
//             draw_set_color(make_color_rgb(150, 150, 150));
//             draw_set_halign(fa_center);
//             draw_text(_start_x + 300, _btn_y + 35, "+ TẠO MỚI +");
//             draw_set_halign(fa_left);
//         } else {
//             // Icon / Avatar giả
//             draw_set_color(make_color_rgb(60, 180, 80));
//             draw_circle(_start_x + 50, _btn_y + 50, 30, false);
//             draw_set_color(c_white);
//             draw_set_halign(fa_center); draw_set_valign(fa_middle);
//             draw_text(_start_x + 50, _btn_y + 50, string_char_at(slot_names[i], 1)); // Chữ cái đầu
//             draw_set_halign(fa_left); draw_set_valign(fa_top);
            
//             // In tên chủ nông trại
//             draw_set_color(make_color_rgb(0, 255, 150)); // Xanh neon
//             draw_text(_start_x + 100, _btn_y + 20, "Nông Trại: " + slot_names[i]);
            
//             // In số ngày
//             draw_set_color(make_color_rgb(200, 200, 200));
//             draw_text(_start_x + 100, _btn_y + 60, "Đã cày cuốc: " + string(slot_days[i]) + " ngày");
            
//             // Vẽ Nút XÓA
//             if (i != 3) { // Slot 3 là Admin ko cho xóa
//                 var _del_hover = (_mx > _start_x + 480 && _mx < _start_x + 580 && _my > _btn_y + 25 && _my < _btn_y + 75);
//                 draw_set_alpha(_del_hover ? 1.0 : 0.6);
//                 draw_set_color(c_red);
//                 draw_rectangle(_start_x + 480, _btn_y + 25, _start_x + 580, _btn_y + 75, false);
//                 draw_set_alpha(1.0);
//                 draw_set_color(c_white);
//                 draw_text(_start_x + 510, _btn_y + 40, "XÓA");
//             }
//         }
//     }
// }

// =======================================================
// OLD GUI CODE COMMENTED OUT
// =======================================================

// VẼ CON TRỎ CHUỘT CUSTOM Ở TRÊN CÙNG
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);
draw_sprite_ext(spr_mouse, 0, _mx, _my, 1.3, 1.3, 0, c_white, 1);