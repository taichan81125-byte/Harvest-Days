
var _is_hover = position_meeting(mouse_x, mouse_y, id);

if (_is_hover) {
    draw_set_alpha(0.3);
    draw_set_color(make_color_rgb(220, 50, 50));
    draw_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, false);
    draw_set_alpha(1.0);
}
