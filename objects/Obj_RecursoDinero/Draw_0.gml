if (sprite_index != -1) draw_self();
else {
  draw_set_color(c_lime);
  draw_circle(x, y, 12, false);
  draw_set_color(c_black);
  draw_text(x-5, y-8, "$");
  draw_set_color(c_white);
}
