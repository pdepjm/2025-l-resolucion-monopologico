% ---- Parte A ----


%progreso(jugador, casilla, dinero)
progreso(ana, 0, 0).
progreso(beto, 24, 10).
progreso(cari, 31, 3100).
progreso(dani, 38, 50).
ganasDeJugar(ana, 0.6).
ganasDeJugar(beto, 0.8).

ganasDeJugar(Jugador, 0.4) :-
    progreso(Jugador, Posicion, _),
    Posicion > 25.


%¿En qué casilla está Dani?
% Consulta: progreso(dani, Casilla, _).
% Rta:      Casilla = 38.

%¿Hay alguien en la casilla 31?
% Consulta: progreso(_, 31, _).
% Rta:      True.

% No es lo mismo que hacer "progreso(Quien, 31, _)", porque esta consulta
% significa "Quienes estan en la casilla 31?"


%¿Las ganas de jugar de Ana es 0.7?
% Consulta: ganasDeJugar(ana, 0.7).
% Rta:      False.

%¿Quienes tienen 0.4 de ganas de jugar?

% Consulta: ganasDeJugar(Quien, 0.4).
% Rta:      Quien = cari,
%           Quien = dani.

%¿Cuáles son las ganas de jugar de Pepita?
% Consulta: ganasDeJugar(Ganas, pepita).
% Rta:      False.



% ¿Qué diferencias hay entre una función y un predicado?. 

% Hay varias respuestas posibles:

% Los predicados devuelven true o false, las funciones pueden devolver cualquier tipo de dato
% Los predicados son relaciones entre individuos, las funciones transforman una entrada en una salida
% Con los predicados se pueden conseguir quienes hacen verdadera una relacion (inversibilidad, variables libres), con una funcion que devuelve booleano no se puede.
% (Pensando en funciones de C) Las funciones pueden tener efecto (modificar variables), los predicados no.
% (Pensando en diferencias entre Haskell y Prolog) En las funciones se pueden tipar los argumentos, en los predicados no. Haskell es un lenguaje tipado y prolog no.

% Hay mas respuestas posibles.

% Respuestas incorrecta comun:
% "Las funciones son un conjunto de condiciones y los predicados son datos". Es incorrecto porque confunde "funciones" con reglas y "predicados" con hechos.
% Los hechos y reglas son predicados.




% ---- Parte B ----


% Habian 4 cosas para mejorar, habia que encontrar por lo menos 3:

% Mejora 1:
estanEmpatados(Jugador1, Jugador2):-
    progreso(Jugador1, _, Dinero1),
    progreso(Jugador2, _, Dinero2),
    Dinero1 is Dinero2, % Esto es innecesario
    Jugador1 \= Jugador2.

estanEmpatadosMejorado(Jugador1, Jugador2):-
    progreso(Jugador1, _, Dinero),
    progreso(Jugador2, _, Dinero),
    Jugador1 \= Jugador2.

% Esto es mejor porque es mas simple.

% Error comun: Decir que "Dinero1 is Dinero2" se puede mejorar por "Dinero1 = Dinero2". Esto no es una mejora porque es lo mismo.


% Mejora 2:

vaMejor(Jugador):-
    progreso(Jugador, _, _),
    findall(OtroJugador, progreso(OtroJugador,_, _), Jugadores), % Este findall es innecesario
    forall( member(JugadorNoVentajoso, Jugadores), tieneVentaja(Jugador, JugadorNoVentajoso)).


vaMejorMejorado(Jugador):-
    progreso(Jugador, _, _),
    forall(progreso(JugadorNoVentajoso, _), tieneVentaja(Jugador, JugadorNoVentajoso)).

% Esto es mejor porque es mas declarativo/expresivo, no hay que operar con listas.


% Mejora 3:

estaMotivado(Jugador):-
    progreso(Jugador, _, _), % Innecesario, porque vaMejor ya liga Jugador.
    vaMejor(Jugador).

estaMotivadoMejorado(Jugador):-
    vaMejor(Jugador).

% Esto es mejor porque es mas simple, porque saco una linea innecesaria.


% Mejora 4:

estaMotivado(Jugador):-
    progreso(Jugador, _, _),
    forall(tieneVentaja(Jugador, JugadorNoVentajoso), (ganasDeJugar(JugadorNoVentajoso, Ganas), Ganas < 0.5)). % Se puede delegar mas

estaMotivadoMejorado(Jugador):-
    progreso(Jugador, _, _),
    forall(tieneVentaja(Jugador, JugadorNoVentajoso), tienePocasGanas(JugadorNoVentajoso)). % Se puede delegar mas

tienePocasGanas(Jugador):-
    ganasDeJugar(Jugador, Ganas), 
    Ganas < 0,5.

% Esto es mejor porque es mas declarativo/expresivo, el forall se entiende mas rapidamente porque la logica del consecuente esta delegada
% en un predicado cuyo nombre expresa que significa esa logica.


% Error comun: Agregar validacion de que Jugador \= Ventaja en tieneVentaja: 

tieneVentaja(Ventajoso, Jugador):-
    progreso(Ventajoso, _, DineroSuperior),
    progreso(Jugador, _, DineroInferior),
    DineroSuperior >= DineroInferior,
    Ventajoso \= Jugador.

% Esto no es una mejora porque no lo pide el enunciado, y no es necesariamente una buena practica validar 
% que los 2 argumentos sean distintos. De hecho, agregar esta validacion hace que el predicado vaMejor deje de funcionar.



% ---- Parte C ----


propiedad(ana, casaRio).
propiedad(beto, barWollok).
propiedad(beto, restoCool).
propiedad(cari, deptoFamiliar).
propiedad(dani, deptoFamiliar).

% Agregadas despues de la aclaracion durante el parcial. No estaban en el enunciado:
propiedad(dani, casaJujuy).
propiedad(dani, casaMedonza).


provincia(casaRio, buenosAires).
provincia(deptoFamiliar, buenosAires).
provincia(barWollok, cordoba).
provincia(restoCool, cordoba).
provincia(hotelProlog, cordoba).
provincia(casaDeHaskelicia, santaFe).

% Las casas que no estaban en el enunciado
provincia(casaJujuy, jujuy).
provincia(casaJujuy, mendoza).



jugadorProvincial(Jugador, Provincia):-
    propiedad(Jugador, _),
    provincia(_, Provincia),
    forall(propiedad(Jugador, Propiedad), provincia(Propiedad, Provincia)).

provinciaCompleta(Jugador, Provincia):-
    propiedad(Jugador, _),
    provincia(_, Provincia),
    forall(provincia(Propiedad, Provincia), propiedad(Jugador, Propiedad)).


% Son inversibles porque en ambos predicados se agrega los predicados "propiedad" y "provincia" para poder ligar ambas variables.


% ---- Ganador del juego ----


% Se tiene este codigo:

gana(Jugador) : - 
    progreso(Jugador, _, _) , 
    forall(
        tieneObjetivoExpansionista(Jugador,ObjetivoExpansionista), 
        cumpleExpansionista(Jugador,ObjetivoExpansionista)).

gana(Jugador) : - 
    progreso(Jugador, _, _) , 
    forall(
        tieneObjetivoColeccionista(Jugador,ObjetivoColeccionista), 
        cumpleColeccionista(Jugador,ObjetivoColeccionista)).


% A) Parecia andar ya que para Ana y Beto funcionaba correctamente, pero para Dani empezó a fallar. ¿Por qué?

% Rta: Para Dani falla porque devuelve true, cuando deberia devolver false. Esto pasa porque dani cumplio
% un solo objetivo, el expansionista, pero el predicado gana esta planteado como una disyuncion (un OR).
% Por esto, con tal de que una persona cumpla solo uno de sus tipos de objetivo, ya es suficiente para
% considerarlo ganador, cuando enrealidad deberia ganar todos sus objetivos. 

% Esto no lo pedia el enunciado, pero ademas esta solucion tiene un problema de extensbilidad, porque por cada
% nuevo objetivo que quiera agregar voy a tener que agregar una nueva clausula casi identica al predicado gana.


% B) Nos piden implementar un nuevo tipo de objetivo, y arreglar el problema de logica del punto anterior.

% Por como está planteada la solucion, no me sirve ninguno de los predicados ya existentes, osea
% "tieneObjetivoExpansionista", "cumpleExpansionista", "tieneObjetivoColeccionista" y "cumpleColeccionista",
% porque estos predicados nos llevan a un diseño poco extensible y, por lo tanto, dificil de mantener.

% Por esto, voy a tener que rehacer todo, empezando por los hechos:

objetivo(ana, expansionista(5)).
objetivo(beto, coleccionista(buenosAires)).
objetivo(beto, coleccionista(cordoba)).
objetivo(dani, coleccionista(buenosAires)).
objetivo(dani, expansionista(3)).

% Teniendo esta nueva base de conocimientos, puedo rehacer el gana\1 de una forma que soluciona el problema
% y que tambien es mas extensible.

gana(Jugador):-
    objetivo(Jugador, _),
    forall(objetivo(Jugador, Objetivo), cumplio(Jugador, Objetivo)).


cumplio(Jugador, expansionista(CantidadObjetivo)):-
    findall(Propiedad, propiedad(Jugador, Propiedad), Propiedades),
    length(Propiedades, Cantidad),
    Cantidad > CantidadObjetivo.

cumplio(Jugador, coleccionista(Provincia)):-
    provinciaCompleta(Jugador, Provincia).


% Y ahora puedo implementar el nuevo objetivo:

objetivo(cari, superarDeuda(3, 97)).

cumplio(Jugador, superarDeuda(Herencia, Deuda)):-
    progreso(Jugador, _, Dinero),
    Dinero + Herencia > Deuda.

% C) ¿Qué concepto permite, para quien lee el código, entender el objetivo inventado sin tener una consigna que lo explique?

% La expresividad permite entender este objetivo sin tener un enunciado que lo explique. Con solo leer el codigo lo entiendo inmediatamente.

% D) ¿Qué concepto/s del paradigma lógico permitieron que agregar un nuevo tipo de objetivo sea relativamente sencillo?

% Lo que permite implementar nuevos tipos de objetivos facilmente es el polimorfismo, porque lo unico necesario para hacer que el 
% nuevo objetivo funcione es implementar el caso particular del objetivo en el predicado cumplio\2.



% Error comun en esta parte:


% Arreglar el problema de logica pero no hacer una solucion mas extensible:


gana(Jugador) : - 
    progreso(Jugador, _, _) , 
    forall(
        tieneObjetivoExpansionista(Jugador,ObjetivoExpansionista), 
        cumpleExpansionista(Jugador,ObjetivoExpansionista)),
    forall(
        tieneObjetivoColeccionista(Jugador,ObjetivoColeccionista), 
        cumpleColeccionista(Jugador,ObjetivoColeccionista)),
    forall(
        tieneObjetivoInventado(Jugador,ObjetivoColeccionista), 
        cumpleInventado(Jugador,ObjetivoColeccionista)).

% Esta solucion tiene problemas de extensibilidad, tengo que agregar un nuevo forall por cada nuevo objetivo.
% Aunque resuelve el problema, esta solución no es correcta porque no cumple con lo que se siempre se pide en la materia,
% que es hacer buenas (osea, mantenibles) soluciones, no solo hacer andar las cosas.


% Hubieron otras soluciones similares que son poco extensibles, pero la mayoria tenia este problema comun de tener
% un forall por cada objetivo. Lo correcto es que haya un solo forall, como el de la solucion anterior planteada.