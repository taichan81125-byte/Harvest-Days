
draw_set_font(fnt_vietnamese);

var _draw_x = bbox_left;
var _draw_y = bbox_top;
var _h = bbox_bottom - bbox_top;
var _mid_y = bbox_top + _h / 2;

var _is_hover = position_meeting(mouse_x, mouse_y, id);

if (_is_hover) {
    draw_set_alpha(0.1);
    draw_set_color(c_white);
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1.0);
}

if (is_typing) {
    draw_set_color(make_color_rgb(150, 50, 20)); // Chữ đỏ đậm để dễ nhìn trên nền gỗ
    draw_set_halign(fa_left); draw_set_valign(fa_middle);
    draw_text(_draw_x + 50, _mid_y - 15, "Nhập tên: " + new_name + "_farm_");
    
    draw_set_alpha(abs(sin(current_time/200)));
    draw_set_color(make_color_rgb(50, 30, 10)); // Chữ nâu đen
    draw_text(_draw_x + 50, _mid_y + 15, "[Nhấn ENTER để xác nhận | ESC để hủy]");
    draw_set_alpha(1.0);
    draw_set_valign(fa_top);
} else {
    if (player_name == "Trống") {
        draw_set_color(make_color_rgb(100, 70, 40)); // Màu chữ nâu gỗ
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(_draw_x + (bbox_right - bbox_left)/2, _mid_y, "+ TẠO MỚI +");
        draw_set_halign(fa_left); draw_set_valign(fa_top);
    } else {
        // Avatar circle
        draw_set_color(make_color_rgb(60, 180, 80));
        draw_circle(_draw_x + 60, _mid_y, 25, false);
        draw_set_color(c_white);
        draw_set_halign(fa_center); draw_set_valign(fa_middle);
        draw_text(_draw_x + 60, _mid_y, string_char_at(player_name, 1));
        draw_set_halign(fa_left); draw_set_valign(fa_top);
        
        // Farm Name
        draw_set_color(make_color_rgb(20, 100, 20)); // Xanh lá đậm
        draw_text(_draw_x + 110, _mid_y - 25, "Nông Trại: " + player_name);
        
        // Days
        draw_set_color(make_color_rgb(80, 60, 40)); // Màu chữ nâu nhạt
        draw_text(_draw_x + 110, _mid_y + 5, "Đã cày cuốc: " + string(day_count) + " ngày");
    }
}

