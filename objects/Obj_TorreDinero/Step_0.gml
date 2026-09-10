if (global.estado_juego != "jugando") exit;

if (cd_actual > 0) cd_actual--;
else {
  var rec = instance_create_layer(x + random_range(-30, 30), y + random_range(-30, 30), "Instances", Obj_RecursoDinero);
  rec.valor = 10 + (nivel * 5);
  cd_actual = cooldown;
}
