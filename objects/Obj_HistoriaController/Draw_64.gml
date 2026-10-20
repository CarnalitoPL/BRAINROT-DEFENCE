var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Fondo negro
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);

// Dibujar sprite de la historia a pantalla completa
if (sprite_exists(global.historia_sprite)) {
    draw_sprite_stretched(global.historia_sprite, 0, 0, 0, gw, gh);
}

// Indicador animado para continuar
if (tiempo_espera <= 0) {
    alpha_texto += 0.04 * alpha_dir;
    if (alpha_texto >= 1) { alpha_texto = 1; alpha_dir = -1; }
    if (alpha_texto <= 0.3) { alpha_texto = 0.3; alpha_dir = 1; }
    
    draw_set_font(Fnt_juego);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    var txt = "Presiona cualquier tecla para continuar...";
    var tw = string_width(txt) + 30;
    var th = string_height(txt) + 12;
    var bx = gw / 2;
    var by = gh - 28;
    
    // Recuadro semitransparente oscuro detrás del texto
    draw_set_color(c_black);
    draw_set_alpha(0.65 * alpha_texto);
    draw_rectangle(bx - (tw / 2), by - (th / 2), bx + (tw / 2), by + (th / 2), false);
    
    // Texto
    draw_set_color(c_yellow);
    draw_set_alpha(alpha_texto);
    draw_text(bx, by, txt);
    
    // Restaurar valores estándar
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
