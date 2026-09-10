if (global.estado_juego != "jugando") exit;
if (cd_actual > 0) cd_actual--;
else {
  var target = noone;
  var min_dist = rango + 1;
  with (Obj_EnemyParent) {
    if (camuflado && !other.puede_ver_camuflados) continue;
    var dist = point_distance(x, y, other.x, other.y);
    if (dist <= other.rango && dist < min_dist) {
      target = id;
      min_dist = dist;
    }
  }
  if (target != noone) {
    var d = danio;
    if (target.resistente && !perfora_piedra) d = 1;
    target.hp -= d;
    cd_actual = cooldown;
  }
}

