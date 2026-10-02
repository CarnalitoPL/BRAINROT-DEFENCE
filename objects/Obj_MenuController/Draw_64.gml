var bg = asset_get_index(Spr_FondoMenu);
if (bg != -1) {
    draw_sprite_stretched(bg, 0, 0, 0, 1366, 768);
}

draw_set_font(Fnt_juego); // Applying global font here just in case
draw_set_color(c_red);
draw_set_halign(fa_center);
draw_text_transformed(1366/2, 100, "BRAINROT DEFENCE", 3, 3, 0);

if (!en_ajustes) {
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
    
    // Boton Ajustes
    draw_set_color(c_gray);
    draw_rectangle(1366/2 - 150, 580, 1366/2 + 150, 660, false);
    draw_set_color(c_black);
    draw_text_transformed(1366/2, 605, "AJUSTES", 2, 2, 0);
} else {
    // Menu de Ajustes
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(1366/2 - 300, 250, 1366/2 + 300, 680, false);
    draw_set_alpha(1.0);
    
    draw_set_color(c_white);
    draw_text_transformed(1366/2, 280, "AJUSTES", 2, 2, 0);
    
    // Musica
    draw_text(1366/2, 350, "Musica: " + string(round(global.vol_musica * 100)) + "%");
    draw_set_color(c_gray);
    draw_rectangle(1366/2 - 150, 335, 1366/2 - 100, 385, false); // [-]
    draw_rectangle(1366/2 + 100, 335, 1366/2 + 150, 385, false); // [+]
    draw_set_color(c_black);
    draw_text(1366/2 - 125, 345, "-");
    draw_text(1366/2 + 125, 345, "+");
    
    // SFX
    draw_set_color(c_white);
    draw_text(1366/2, 430, "SFX: " + string(round(global.vol_sfx * 100)) + "%");
    draw_set_color(c_gray);
    draw_rectangle(1366/2 - 150, 415, 1366/2 - 100, 465, false); // [-]
    draw_rectangle(1366/2 + 100, 415, 1366/2 + 150, 465, false); // [+]
    draw_set_color(c_black);
    draw_text(1366/2 - 125, 425, "-");
    draw_text(1366/2 + 125, 425, "+");
    
    // Pantalla Completa
    var txt_fs = global.fullscreen ? "Pantalla Completa: SI" : "Pantalla Completa: NO";
    draw_set_color(c_teal);
    draw_rectangle(1366/2 - 200, 500, 1366/2 + 200, 550, false);
    draw_set_color(c_black);
    draw_text(1366/2, 510, txt_fs);
    
    // Boton Volver
    draw_set_color(c_maroon);
    draw_rectangle(1366/2 - 150, 600, 1366/2 + 150, 650, false);
    draw_set_color(c_white);
    draw_text(1366/2, 610, "VOLVER");
}

draw_set_halign(fa_left);
draw_set_color(c_white);
