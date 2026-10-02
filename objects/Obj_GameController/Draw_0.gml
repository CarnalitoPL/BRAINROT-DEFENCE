if (estado_colocacion > 0) {
    var _obj = torres_info[estado_colocacion].obj;
    var _rango = torres_info[estado_colocacion].rango;

    if (_obj != noone) {
        // Rojo si la posicion no es valida
        var _col = (motivo_invalido == "") ? c_white : c_red;

        // Rango de la torre
        draw_set_alpha(0.35);
        draw_set_color(_col);
        draw_circle(mouse_x, mouse_y, _rango, false);

        // Borde del rango para mayor claridad
        draw_set_alpha(0.8);
        draw_circle(mouse_x, mouse_y, _rango, true);

        draw_set_alpha(1.0);
        draw_set_color(c_white);

        // Sprite fantasma
        var _spr = object_get_sprite(_obj);
        if (_spr != -1) {
            draw_sprite_ext(_spr, 0, mouse_x, mouse_y, 1, 1, 0, _col, 0.6);
        } else {
            draw_set_alpha(0.6);
            draw_set_color(_col);
            draw_rectangle(mouse_x - 16, mouse_y - 16, mouse_x + 16, mouse_y + 16, false);
            draw_set_alpha(1.0);
            draw_set_color(c_white);
        }
    }
}
