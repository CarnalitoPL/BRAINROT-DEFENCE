if (sprite_index != -1) {
    draw_sprite_ext(sprite_index, 0, x, y, 1, 1, angulo, c_white, 1);
} else {
    draw_set_color(make_color_rgb(139, 69, 19));
    var length = 30;
    var ex = x + length * dcos(angulo);
    var ey = y - length * dsin(angulo);
    draw_line_width(x, y, ex, ey, 6);
    draw_set_color(c_white);
}
