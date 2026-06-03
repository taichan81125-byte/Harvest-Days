depth = 99;
state = 0; // 0: Khô, 1: Đã Cuốc
is_watered = false;
is_fertilized = false;
is_infected = false;
has_weed = false; // Biến kiểm tra xem đất có bị mọc cỏ dại không

plant_stage = 0; // 0: Trống, 1: Hạt, 2: Mầm, 3: Chín, 4: CHẾT/HÉO (Trạng thái mới)
plant_type = -1; // Để nhớ xem đang trồng Cà chua hay Ngô

// HỆ THỐNG THỜI GIAN THỰC (60 frame = 1 giây)
growth_timer = 0;
growth_max = 600; // Mặc định 10 giây để qua 1 giai đoạn lớn

rot_timer = 0;
rot_max = 1200; // 20 giây bị sâu cắn hoặc quên hái sẽ chết

is_neglected = false; // Biến theo dõi xem cây có từng bị bỏ bê không