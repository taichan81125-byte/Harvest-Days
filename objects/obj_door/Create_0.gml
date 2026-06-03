// ==========================================
// CỬA CHUYỂN PHÒNG (DOOR TRANSITION)
// ==========================================
// Mặc định: quay về nông trại (khi thoát khỏi nhà)
target_room = rm_farm;
target_x = 2576;    // Vị trí spawn ngay trước cửa nhà ở rm_farm
target_y = 1562;

// Ẩn cửa (chỉ dùng collision mask để phát hiện player)
image_alpha = 0;

// Cooldown để tránh player bị chuyển room ngay lập tức khi vừa xuất hiện
cooldown = 30; // 30 frames = 0.5 giây
