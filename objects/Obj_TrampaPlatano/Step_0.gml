if (global.estado_juego != "jugando") exit;

with (Obj_EnemyParent) {
    if (point_distance(x, y, other.x, other.y) < 20) {
        var already_hit = false;
        for (var i = 0; i < array_length(other.hit_array); i++) {
            if (other.hit_array[i] == id) {
                already_hit = true; break;
            }
        }
        
        if (!already_hit) {
            array_push(other.hit_array, id);
            
            var d = other.danio;
            if (resistente && !other.perfora_piedra) d = 1;
            hp -= d;
            
            current_speed -= 0.5;
            current_speed = max(0.5, current_speed);
            alarm[1] = 90;
            
            other.usos_restantes--;
            if (other.usos_restantes <= 0) {
                instance_destroy(other);
                break;
            }
        }
    }
}
