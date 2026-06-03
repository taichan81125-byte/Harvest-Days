if (room == rm_farm) {
    // Lưu lại trạng thái của tất cả đất cuốc trước khi rời khỏi nông trại
    // vì chúng ta không thể truy cập obj_dirt từ phòng khác (ví dụ rm_house)
    farm_dirt_data = [];
    with (obj_dirt) {
        array_push(other.farm_dirt_data, {
            _x: x,
            _y: y,
            _state: state,
            _is_watered: is_watered,
            _is_fertilized: is_fertilized,
            _is_infected: is_infected,
            _has_weed: has_weed,
            _is_neglected: is_neglected,
            _plant_stage: plant_stage,
            _plant_type: plant_type,
            _growth_timer: growth_timer,
            _rot_timer: rot_timer
        });
    }
}
