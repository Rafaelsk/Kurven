with variables_esp_curv;	use variables_esp_curv;
with Ada.Text_IO; 			use Ada.Text_IO;

Package biblioteca_esp_curv is
	Procedure lee_archivo_de_datos(Nombre: in String);
	Procedure calcula_tiempo_levantamiento;
	function  parametros_recta( PA, PB : in COORDENADA) return COORDENADA;
	Procedure calcula_tiempo_asentamiento;
	Procedure calcula_sobrepasomaximo;
	Procedure especificaciones_curva(Nombre_Archivo: in String; Tiemp_levant, Tiemp_asent, Sobre_Paso: out float);
End biblioteca_esp_curv;
