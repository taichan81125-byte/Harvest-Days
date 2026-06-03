// Hủy bỏ các đối tượng lưu trữ thông tin khi quay về Menu
// Điều này đảm bảo khi tạo mới hoặc tải map khác, chúng sẽ được khởi tạo lại sạch sẽ.

if (instance_exists(obj_player)) {
    instance_destroy(obj_player);
}

if (instance_exists(obj_game_manager)) {
    instance_destroy(obj_game_manager);
}
