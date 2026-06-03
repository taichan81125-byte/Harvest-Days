if (plant_stage > 0) {
    // 1. GIAI ĐOẠN ĐANG LỚN (Giai đoạn 1 và 2)
    if (plant_stage < 3) {
        var _req_season = 0;
        if (plant_type >= 9 && plant_type <= 12) _req_season = 0;
        else if (plant_type >= 13 && plant_type <= 14) _req_season = 1;
        else if (plant_type >= 15 && plant_type <= 16) _req_season = 2;
        else if (plant_type == 17) _req_season = 3;
        
        var _can_grow = (obj_game_manager.current_season == _req_season);

        // Cây chỉ lớn khi ĐÚNG MÙA, có nước VÀ không bị bệnh
        if (_can_grow == true && is_watered == true && is_infected == false) {
            // Tốc độ lớn được chuẩn hóa theo tốc độ thời gian của map
            var _speed_mult = 5.0 / obj_game_manager.frames_per_game_minute;
            growth_timer += _speed_mult;
            
            // Đủ thời gian -> Cây lớn lên 1 cấp
            if (growth_timer >= growth_max) {
                plant_stage += 1;
                if (plant_stage == 3 && has_weed == true) {
                    is_neglected = true; // Bị hạ hạng vì có cỏ dại lúc ra quả
                }
                growth_timer = 0; // Reset lại đồng hồ lớn
                rot_timer = 0;    // Reset lại đồng hồ héo
                is_watered = false; // Tiêu hao nước cho giai đoạn sau
            }
        }
        
        // Cỏ dại không còn làm giảm chất lượng liên tục nữa, chỉ kiểm tra lúc ra quả
        
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