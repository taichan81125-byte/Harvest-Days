if (plant_stage > 0) {
    // 1. GIAI ĐOẠN ĐANG LỚN (Giai đoạn 1 và 2)
    if (plant_stage < 3) {
        // Cây chỉ lớn khi có nước VÀ không bị bệnh (có cỏ dại VẪN LỚN)
        if (is_watered == true && is_infected == false) {
            growth_timer += 1;
            
            // Mỗi giai đoạn cần đúng 1 ngày (24 giờ) = 24 * 60 * 5 = 7200 frames
            var _current_max = 7200;
            
            // Đủ thời gian -> Cây lớn lên 1 cấp
            if (growth_timer >= _current_max) {
                plant_stage += 1;
                growth_timer = 0; // Reset lại đồng hồ lớn
                rot_timer = 0;    // Reset lại đồng hồ héo
            }
        }
        
        // Cỏ dại làm giảm chất lượng (is_neglected) nhưng KHÔNG làm ngừng lớn
        if (has_weed == true) {
            is_neglected = true; 
        }
        
        // Nếu bị sâu bệnh -> Ngừng lớn, bắt đầu tính giờ chết (12 giờ = 3600 frames)
        if (is_infected == true) {
            is_neglected = true;
            rot_timer += 1;
            if (rot_timer >= 3600) {
                plant_stage = 4; // Quá 12 tiếng không cứu -> Cây chết
            }
        }
    }
    
    // Đã xóa hoàn toàn logic thối hỏng (plant_stage = 4) ở Giai đoạn 3 khi bỏ quên
    // Sẽ được xử lý thối ở obj_game_manager khi NGỦ QUA ĐÊM (chuyển ngày)
}