if (global.estado_juego != "jugando") { path_speed = 0; if (alarm[1] > 0) alarm[1]++; exit; }
else { path_speed = current_speed; }
if (hp <= 0) {
  global.dinero += valor;
  instance_destroy();
}
if (path_position >= 0.99) {
  global.vida -= 10;
  audio_play_sound(Snd_RestarVida, 1, false, global.vol_sfx);
  instance_destroy();
}

if (direction > 90 && direction < 270) {
    image_xscale = -1;
} else if (direction < 90 || direction > 270) {
    image_xscale = 1;
}
