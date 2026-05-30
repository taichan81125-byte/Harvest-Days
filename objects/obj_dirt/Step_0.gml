if (plant_stage > 0) {
    // 1. GIAI ĐOẠN ĐANG LỚN (Giai đoạn 1 và 2)
    if (plant_stage < 3) {
        // Cây chỉ lớn khi có nước, không bị bệnh VÀ không có cỏ dại
        if (is_watered == true && is_infected == false && has_weed == false) {
            growth_timer += 1;
            
            // Đủ thời gian -> Cây lớn lên 1 cấp
            if (growth_timer >= growth_max) {
                plant_stage += 1;
                growth_timer = 0; // Reset lại đồng hồ lớn
                rot_timer = 0;    // Reset lại đồng hồ héo
            }
        }
        
        // Nếu bị sâu bệnh hoặc cỏ dại -> Ngừng lớn, đánh dấu bỏ bê, bắt đầu tính thời gian HÉO
        if (is_infected == true || has_weed == true) {
            is_neglected = true; // ĐÃ THÊM: Đánh dấu cây bị giảm chất lượng
            
            rot_timer += 1;
            if (rot_timer >= rot_max) {
                plant_stage = 4; // Cây bị héo chết
            }
        }
    }
    
    // 2. GIAI ĐOẠN CHÍN (Giai đoạn 3)
    else if (plant_stage == 3) {
        // Bắt đầu đếm ngược, nếu không hái sẽ thối rữa
        rot_timer += 1;
        if (rot_timer >= rot_max) {
            plant_stage = 4; // Quả bị thối
        }
    }
}