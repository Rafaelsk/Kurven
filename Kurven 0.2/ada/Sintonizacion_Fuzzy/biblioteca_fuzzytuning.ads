With variables_fuzzytuning;	use variables_fuzzytuning;


Package biblioteca_fuzzytuning is
	Procedure Fuzzificar;
	Procedure Inferencia_Fuzzy;
	function Min(A,B : in Float) return Float;
	Function Max(A,B :in Float) return Float;
	Function Max_3(A,B,C :in Float) return Float;
	Procedure Desfuzzificar;
	procedure calcular_ganancias_pi(k, tau: in float);
	Procedure mostrar_resultado;
	function guarda_resultado(Nombre_Salida : in string) return Boolean;
end biblioteca_fuzzytuning;
