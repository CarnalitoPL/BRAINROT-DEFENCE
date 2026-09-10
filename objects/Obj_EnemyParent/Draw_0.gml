if (sprite_index != -1) {
    draw_self();
} else {
    draw_set_color(c_red);
    draw_circle(x, y, 16, false);
    draw_set_color(c_white);
}
