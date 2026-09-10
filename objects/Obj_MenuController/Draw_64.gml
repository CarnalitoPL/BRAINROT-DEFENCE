draw_set_font(Fnt_juego); // Applying global font here just in case
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text_transformed(1366/2, 200, "BRAINROT DEFENCE", 3, 3, 0);

if (nivel_guardado != "") {
    // Boton Continuar
    draw_set_color(c_aqua);
    draw_rectangle(1366/2 - 150, 380, 1366/2 + 150, 460, false);
    draw_set_color(c_black);
    draw_text_transformed(1366/2, 405, "CONTINUAR", 2, 2, 0);
    
    // Boton Nueva Partida
    draw_set_color(c_green);
    draw_rectangle(1366/2 - 150, 480, 1366/2 + 150, 560, false);
    draw_set_color(c_black);
    draw_text_transformed(1366/2, 505, "NUEVA PARTIDA", 2, 2, 0);
} else {
    // Solo Jugar
    draw_set_color(c_green);
    draw_rectangle(1366/2 - 150, 400, 1366/2 + 150, 480, false);
    draw_set_color(c_black);
    draw_text_transformed(1366/2, 425, "JUGAR", 2, 2, 0);
}

draw_set_halign(fa_left);
draw_set_color(c_white);
