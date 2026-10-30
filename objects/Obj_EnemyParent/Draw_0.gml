draw_self();

if (variable_global_exists("mostrar_vida_enemigos") && global.mostrar_vida_enemigos && hp > 0) {
    if (!variable_instance_exists(id, "hp_max") || hp_max <= 0) hp_max = max(hp, 1);
    
    var bar_w = 34;
    var bar_h = 5;
    var bar_x = round(x - (bar_w / 2));
    var bar_y = round(bbox_top - 8);
    var pct = clamp(hp / hp_max, 0, 1);
    
    var prev_alpha = draw_get_alpha();
    draw_set_alpha(image_alpha);
    
    // Fondo oscuro / rojo
    draw_set_color(c_maroon);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    
    // Barra de vida verde
    if (pct > 0) {
        draw_set_color(c_lime);
        draw_rectangle(bar_x, bar_y, bar_x + round(bar_w * pct), bar_y + bar_h, false);
    }
    
    // Borde negro
    draw_set_color(c_black);
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, true);
    
    draw_set_alpha(prev_alpha);
    draw_set_color(c_white);
}
