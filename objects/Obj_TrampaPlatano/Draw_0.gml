if (sprite_index != -1) {
    draw_self();
} else {
    draw_set_color(c_yellow);
    draw_circle(x, y, 6, false);
    draw_set_color(c_black);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text_transformed(x, y, string(usos_restantes), 0.7, 0.7, 0);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
