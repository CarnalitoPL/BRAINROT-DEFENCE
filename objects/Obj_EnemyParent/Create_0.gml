hp = 10;
speed_base = 2;
valor = 5;
camuflado = false;
resistente = false;
var _path = Path_Enemy;
if (room == Rm_Ciudad) _path = Path_Ciudad;
else if (room == Rm_Bosque) _path = Path_Bosque;
else if (room == Rm_Mar) _path = Path_Mar;

path_start(_path, speed_base, path_action_stop, true);

current_speed = speed_base;
