if (estado_colocacion > 0) {
    var _obj = noone;
    var _rango = 100;
    
    if (estado_colocacion == 1) { _obj = Obj_TorreTripleT; _rango = 60; }
    else if (estado_colocacion == 2) { _obj = Obj_TorreCapuchino; _rango = 100; }
    else if (estado_colocacion == 3) { _obj = Obj_TorreChimpancini; _rango = 150; }
    else if (estado_colocacion == 4) { _obj = Obj_TorreDinero; _rango = 100; }
    
    if (_obj != noone) {
        // Rango de la torre
        draw_set_alpha(0.35);
        draw_set_color(c_white);
        draw_circle(mouse_x, mouse_y, _rango, false);
        
        // Borde del rango para mayor claridad
        draw_set_alpha(0.8);
        draw_circle(mouse_x, mouse_y, _rango, true);
        
        draw_set_alpha(1.0);
        draw_set_color(c_white);
        
        // Sprite fantasma
        var _spr = object_get_sprite(_obj);
        if (_spr != -1) {
            draw_sprite_ext(_spr, 0, mouse_x, mouse_y, 1, 1, 0, c_white, 0.6);
        }
    }
}
