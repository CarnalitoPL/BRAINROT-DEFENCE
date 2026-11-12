if (global.estado_juego != "jugando") { speed = 0; exit; }
else { speed = velocidad_proyectil; }

if (instance_exists(target)) {
  move_towards_point(target.x, target.y, velocidad_proyectil);
  if (point_distance(x, y, target.x, target.y) <= velocidad_proyectil) {
    var d = danio;
    if (target.resistente && !perfora_piedra) d = max(1, floor(d / 2));
    target.hp -= d;
    instance_destroy();
  }
} else { instance_destroy(); }
