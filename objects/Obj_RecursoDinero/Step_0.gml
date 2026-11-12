if (global.estado_juego == "pausado" || global.estado_juego == "game_over" || global.estado_juego == "victoria") exit;
tiempo_vida--;
if (tiempo_vida <= 0) instance_destroy();
if (mouse_check_button_pressed(mb_left)) {
  if (point_distance(mouse_x, mouse_y, x, y) < 40) {
    global.dinero += valor;
    var _snd = asset_get_index("Snd_AgarrarDinero");
    if (_snd != -1) audio_play_sound(_snd, 1, false, global.vol_sfx);
    instance_destroy();
  }
}
