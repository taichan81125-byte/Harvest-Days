// 1. QUẢN LÝ TÊN FILE CỦA 4 SLOT
slot_files = ["slot1.ini", "slot2.ini", "slot3.ini", "slot4.ini"];
slot_names = ["Trống", "Trống", "Trống", "Trống"];
slot_days = [0, 0, 0, 0];

// 2. ĐỌC DỮ LIỆU TỪ Ổ CỨNG XEM SLOT NÀO ĐÃ CÓ NGƯỜI CHƠI
for(var i = 0; i < 4; i++) {
    if (file_exists(slot_files[i])) {
        ini_open(slot_files[i]);
        slot_names[i] = ini_read_string("Info", "owner_name", "Nong Dan");
        slot_days[i] = ini_read_real("Game", "day_count", 1);
        ini_close();
    }
}

// 3. CÁC BIẾN QUẢN LÝ VIỆC GÕ BÀN PHÍM ĐỂ ĐẶT TÊN
is_typing = false;
typing_slot = -1;
new_name = "";