ini_open("save.ini");
nivel_guardado = ini_read_string("Progreso", "Nivel", "");
global.vol_musica = ini_read_real("Config", "Musica", 1.0);
global.vol_sfx = ini_read_real("Config", "SFX", 1.0);
global.fullscreen = ini_read_real("Config", "Fullscreen", 0);
ini_close();

window_set_fullscreen(global.fullscreen);
en_ajustes = false;

audio_stop_all();
musica_actual = audio_play_sound(Snd_MusicaDeFondo, 1, true, global.vol_musica);
