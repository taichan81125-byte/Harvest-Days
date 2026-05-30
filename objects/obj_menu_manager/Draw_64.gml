// Chọn Font tiếng Việt của chúng ta
draw_set_font(fnt_vietnamese);

// Căn lề chữ vào chính giữa
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 1. VẼ TIÊU ĐỀ GAME (Phóng to gấp 3 lần)
draw_set_color(c_yellow);
// Hàm này vẽ chữ ở tọa độ (X=640, Y=250), to gấp 3 lần (xscale=3, yscale=3), không xoay (angle=0)
draw_text_transformed(640, 250, "HARVEST DAYS", 3, 3, 0);

// 2. VẼ PHỤ ĐỀ
draw_set_color(c_white);
// Hàm này vẽ chữ cỡ bình thường, to gấp 1.5 lần
draw_text_transformed(640, 320, "Một ngày thu hoạch bình yên", 1.5, 1.5, 0);

// 3. VẼ DÒNG CHỮ HƯỚNG DẪN NHẤP NHÁY
draw_set_alpha(text_alpha); // Áp dụng độ mờ từ sự kiện Step
draw_set_color(c_yellow);

// ĐÃ SỬA: Chỉ còn 1 dòng hướng dẫn duy nhất
draw_text(640, 550, "[Nhấn SPACE hoặc ENTER để bắt đầu]");

draw_set_alpha(1.0); // BẮT BUỘC TRẢ LẠI ĐỘ ĐỤC BÌNH THƯỜNG KHÔNG SẼ LỖI HÌNH KHÁC

// BẮT BUỘC TRẢ LẠI CĂN LỀ TRÁI/TRÊN NHƯ MẶC ĐỊNH (Để không làm hỏng UI trong game)
draw_set_halign(fa_left);
draw_set_valign(fa_top);