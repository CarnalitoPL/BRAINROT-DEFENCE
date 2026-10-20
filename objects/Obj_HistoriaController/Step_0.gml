if (tiempo_espera > 0) {
    tiempo_espera--;
    exit;
}

// Al presionar cualquier tecla o cualquier boton del raton, avanzar a lo que sigue
if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_left) || mouse_check_button_pressed(mb_right) || mouse_check_button_pressed(mb_middle)) {
    var rm = global.historia_siguiente_room;
    if (rm != noone && room_exists(rm)) {
        room_goto(rm);
    } else {
        room_goto(Rm_MenuInit);
    }
}
