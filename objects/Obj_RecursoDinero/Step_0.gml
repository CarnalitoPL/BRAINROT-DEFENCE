if (global.estado_juego == "pausado" || global.estado_juego == "game_over" || global.estado_juego == "victoria") exit;
tiempo_vida--;
if (tiempo_vida <= 0) instance_destroy();
if (mouse_check_button_pressed(mb_left)) {
  if (point_distance(mouse_x, mouse_y, x, y) < 30) {
    global.dinero += valor;
    instance_destroy();
  }
}
