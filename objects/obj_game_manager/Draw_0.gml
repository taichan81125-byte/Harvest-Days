// ==========================================
// VẼ HÌNH NỀN NHÀ NÔNG DÂN (KHI Ở TRONG NHÀ)
// ==========================================
if (room == rm_house && variable_global_exists("spr_house_bg") && global.spr_house_bg != -1) {
    draw_sprite_stretched(global.spr_house_bg, 0, 0, 0, room_width, room_height);
}
