if (global.estado_juego != "jugando") exit;

if (cd_actual > 0) cd_actual--;
else {
  var rec = instance_create_layer(x + random_range(-30, 30), y + random_range(-30, 30), "Instances", Obj_RecursoDinero);
  rec.valor = 15 + (nivel - 1) * 10; // 15, 25, 35, 45, 55
  cd_actual = cooldown;
}
