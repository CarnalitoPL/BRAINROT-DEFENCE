if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    if (nivel_guardado != "") {
        // Clic en Continuar
        if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 380 && my < 460) {
            var rm = asset_get_index(nivel_guardado);
            if (rm != -1) room_goto(rm);
            else room_goto(Rm_Ciudad);
        }
        // Clic en Nueva Partida
        else if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 480 && my < 560) {
            if (file_exists("save.ini")) file_delete("save.ini");
            room_goto(Rm_Ciudad);
        }
    } else {
        // Clic en Jugar
        if (mx > 1366/2 - 150 && mx < 1366/2 + 150 && my > 400 && my < 480) {
            if (file_exists("save.ini")) file_delete("save.ini");
            room_goto(Rm_Ciudad);
        }
    }
}
