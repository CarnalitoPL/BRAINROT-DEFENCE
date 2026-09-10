if (global.estado_juego != "jugando") exit;
if (cd_actual > 0) cd_actual--;
else {
    var _path = Path_Enemy;
    if (room == Rm_Ciudad) _path = Path_Ciudad;
    else if (room == Rm_Bosque) _path = Path_Bosque;
    else if (room == Rm_Mar) _path = Path_Mar;
    
    var valid_positions = [];
    for (var p = 0.0; p <= 1.0; p += 0.02) {
        var px = path_get_x(_path, p);
        var py = path_get_y(_path, p);
        if (point_distance(x, y, px, py) <= rango) {
            array_push(valid_positions, p);
        }
    }
    
    if (array_length(valid_positions) > 0) {
        var rnd_idx = irandom(array_length(valid_positions) - 1);
        var final_pos = valid_positions[rnd_idx];
        var final_x = path_get_x(_path, final_pos);
        var final_y = path_get_y(_path, final_pos);
        
        var trampa = instance_create_layer(final_x, final_y, "Instances", Obj_TrampaPlatano);
        trampa.usos_restantes = 1 + nivel;
        trampa.danio = danio;
        trampa.perfora_piedra = perfora_piedra;
        cd_actual = cooldown;
    }
}
