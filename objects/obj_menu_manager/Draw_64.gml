// 1. Vẽ hình nền menu mới (trải rộng full màn hình, cắt bỏ viền trong suốt ở 2 bên)
draw_sprite_part_ext(spr_nen_game, 0, 20, 0, 600, 360, 0, 0, 1280/600, 720/360, c_white, 1);

// BẮT BUỘC TRẢ LẠI CĂN LỀ TRÁI/TRÊN NHƯ MẶC ĐỊNH (Để không làm hỏng UI trong game)
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// VẼ CON TRỎ CHUỘT CUSTOM (To hơn 30%)
draw_sprite_ext(spr_mouse, 0, device_mouse_x_to_gui(0), device_mouse_y_to_gui(0), 1.3, 1.3, 0, c_white, 1);