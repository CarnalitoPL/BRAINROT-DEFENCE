if (global.estado_juego != "jugando") exit;
if (cd_actual > 0) cd_actual--;

var target = noone;
var min_dist = rango + 1;
with (Obj_EnemyParent) {
    if (camuflado && !other.puede_ver_camuflados) continue;
    var dist = point_distance(other.x, other.y, x, y);
    if (dist <= other.rango && dist < min_dist) {
        target = id;
        min_dist = dist;
    }
}

if (target != noone) {
    var angulo = point_direction(x, y, target.x, target.y);
    var dir = round(angulo / 90) mod 4;
    
    if (dir == 0) sprite_index = spr_right;
    else if (dir == 1) sprite_index = spr_up;
    else if (dir == 2) sprite_index = spr_left;
    else if (dir == 3) sprite_index = spr_down;
    
    if (cd_actual <= 0) {
        var d = danio;
        if (target.resistente && !perfora_piedra) d = 1;
        target.hp -= d;
        
        var bate = instance_create_layer(x + lengthdir_x(20, angulo), y + lengthdir_y(20, angulo), "Instances", Obj_EfectoBate);
        bate.angulo = angulo;
        
        cd_actual = cooldown;
    }
}


