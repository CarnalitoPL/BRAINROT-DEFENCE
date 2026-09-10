if (global.estado_juego != "jugando") {
    alarm[0] = 60;
    exit;
}

if (current_wave_index >= array_length(waves)) {
    exit;
}

var current_wave = waves[current_wave_index];
var current_instruction = current_wave[current_subwave_index];

instance_create_layer(0, 0, "Instances", current_instruction.obj);
enemies_spawned_in_subwave++;

if (enemies_spawned_in_subwave >= current_instruction.count) {
    enemies_spawned_in_subwave = 0;
    current_subwave_index++;
    
    if (current_subwave_index >= array_length(current_wave)) {
        current_subwave_index = 0;
        current_wave_index++;
        global.oleada++;
        alarm[0] = 180; // Tiempo entre oleadas
        exit;
    }
}

// Ensure the alarm is set for the next spawn, even if it just shifted to a new instruction in the same wave
if (current_subwave_index < array_length(current_wave)) {
    var next_instruction = current_wave[current_subwave_index];
    alarm[0] = next_instruction.delay;
}
