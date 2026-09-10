if (sprite_index != -1) {
    draw_self();
} else {
    var _c = variable_instance_exists(id, "color_placeholder") ? color_placeholder : c_blue;
    draw_set_color(_c);
    draw_rectangle(x - 16, y - 16, x + 16, y + 16, false);
    draw_set_color(c_white);
}

// Draw range circle if selected
if (instance_exists(Obj_GameController) && Obj_GameController.torre_seleccionada == id) {
    draw_set_color(c_lime);
    draw_circle(x, y, rango, true);
    draw_set_color(c_white);
}
