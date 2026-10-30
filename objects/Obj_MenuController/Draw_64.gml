draw_sprite_stretched(Spr_FondoMenu, 0, 0, 0, 1366, 768);

draw_set_font(Fnt_juego); // Applying global font here just in case
draw_set_color(c_red);
draw_set_halign(fa_center);
draw_text_transformed(1366/2, 100, "BRAINROT DEFENCE", 3, 3, 0);

if (!en_ajustes) {
    if (nivel_guardado != "") {
        // Boton Continuar
        draw_set_color(c_aqua);
        draw_rectangle(1366/2 - 150, 330, 1366/2 + 150, 395, false);
        draw_set_color(c_black);
        draw_text_transformed(1366/2, 350, "CONTINUAR", 1.8, 1.8, 0);
        
        // Boton Nueva Partida
        draw_set_color(c_green);
        draw_rectangle(1366/2 - 150, 410, 1366/2 + 150, 475, false);
        draw_set_color(c_black);
        draw_text_transformed(1366/2, 430, "NUEVA PARTIDA", 1.8, 1.8, 0);
        
        // Boton Ajustes
        draw_set_color(c_gray);
        draw_rectangle(1366/2 - 150, 490, 1366/2 + 150, 555, false);
        draw_set_color(c_black);
        draw_text_transformed(1366/2, 510, "AJUSTES", 1.8, 1.8, 0);
        
        // Boton Salir
        draw_set_color(c_maroon);
        draw_rectangle(1366/2 - 150, 570, 1366/2 + 150, 635, false);
        draw_set_color(c_white);
        draw_text_transformed(1366/2, 590, "SALIR", 1.8, 1.8, 0);
    } else {
        // Solo Jugar
        draw_set_color(c_green);
        draw_rectangle(1366/2 - 150, 370, 1366/2 + 150, 440, false);
        draw_set_color(c_black);
        draw_text_transformed(1366/2, 395, "JUGAR", 2, 2, 0);
        
        // Boton Ajustes
        draw_set_color(c_gray);
        draw_rectangle(1366/2 - 150, 460, 1366/2 + 150, 530, false);
        draw_set_color(c_black);
        draw_text_transformed(1366/2, 485, "AJUSTES", 2, 2, 0);
        
        // Boton Salir
        draw_set_color(c_maroon);
        draw_rectangle(1366/2 - 150, 550, 1366/2 + 150, 620, false);
        draw_set_color(c_white);
        draw_text_transformed(1366/2, 575, "SALIR", 2, 2, 0);
    }
} else {
    // Menu de Ajustes
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_rectangle(1366/2 - 300, 180, 1366/2 + 300, 700, false);
    draw_set_alpha(1.0);
    
    draw_set_color(c_white);
    draw_text_transformed(1366/2, 210, "AJUSTES", 2, 2, 0);
    
    // Musica
    draw_text(1366/2, 265, "Musica: " + string(round(global.vol_musica * 100)) + "%");
    draw_set_color(c_gray);
    draw_rectangle(1366/2 - 150, 250, 1366/2 - 100, 295, false); // [-]
    draw_rectangle(1366/2 + 100, 250, 1366/2 + 150, 295, false); // [+]
    draw_set_color(c_black);
    draw_text(1366/2 - 125, 260, "-");
    draw_text(1366/2 + 125, 260, "+");
    
    // SFX
    draw_set_color(c_white);
    draw_text(1366/2, 335, "SFX: " + string(round(global.vol_sfx * 100)) + "%");
    draw_set_color(c_gray);
    draw_rectangle(1366/2 - 150, 320, 1366/2 - 100, 365, false); // [-]
    draw_rectangle(1366/2 + 100, 320, 1366/2 + 150, 365, false); // [+]
    draw_set_color(c_black);
    draw_text(1366/2 - 125, 330, "-");
    draw_text(1366/2 + 125, 330, "+");
    
    // Pantalla Completa
    var txt_fs = global.fullscreen ? "Pantalla Completa: SI" : "Pantalla Completa: NO";
    draw_set_color(c_teal);
    draw_rectangle(1366/2 - 200, 390, 1366/2 + 200, 440, false);
    draw_set_color(c_black);
    draw_text(1366/2, 402, txt_fs);
    
    // Barra de Vida en Peces (Activar / Desactivar)
    var txt_vida = global.mostrar_vida_enemigos ? "Vida en Peces: SI" : "Vida en Peces: NO";
    draw_set_color(c_teal);
    draw_rectangle(1366/2 - 200, 460, 1366/2 + 200, 510, false);
    draw_set_color(c_black);
    draw_text(1366/2, 472, txt_vida);
    
    // Boton Volver
    draw_set_color(c_maroon);
    draw_rectangle(1366/2 - 150, 560, 1366/2 + 150, 615, false);
    draw_set_color(c_white);
    draw_text(1366/2, 575, "VOLVER");
}

draw_set_halign(fa_left);
draw_set_color(c_white);
