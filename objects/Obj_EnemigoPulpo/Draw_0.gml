if (sprite_index != -1) {
    if (!camuflado) {
        draw_self();
    } else {
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_white, 0.3);
    }
} else {
    if (!camuflado) {
        draw_set_color(c_purple);
    } else {
        draw_set_color(c_fuchsia);
        draw_set_alpha(0.3);
    }
    draw_circle(x, y, 16, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
