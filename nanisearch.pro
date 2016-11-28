%empieza el juego.
inicio:-
	nani_search.
	
nani_search:-  
	write('BIENVENIDOS AL JUEGO NANI SEARCH'), nl,
	write('Alexia es una niña de 8 años que perdio su Nani y el cual necesita para dormir.'), nl,
	write('Ayudala a buscar su Nani y gana el juego sin morir en el intento.'), nl, nl,
	write('TIPS'), nl,
	write('En las habitaciones de la casa hay notas las cuales son pistas para encontrar a Nani.'), nl,
	write('Si te rindes solo escribe terminar'), nl, nl,
	here(X),
	prenderluces(X), nl,
	write('Busca la llave, eso te será de utilidad.'), nl,
	write('Pista: Es un lugar muy largo poco angosto si eres astuta lo encontraras'), nl, 
	command_loop.
	
%lenguaje natural	
init:-
	op(33,fx,goto),
   op(34,fx,abrir_puerta),
   op(35,fx,prenderluces),
	op(36,fx,take),
	op(37,fx,eat),
	op(38,fx,drink),
	op(39,fx,drop),
	op(40,fx,apagarluces),
	op(41,fx,cerrar_puerta).
	
command_loop:-
	init,
	write('Bienvenidos al jugo Busca a Nani'), nl,
	repeat,
	write('>NANI> '),
	read(X),
	do(X), nl,
	end_condition(X).
	
end_condition(terminar):-
	write('FALLASTE').
	
end_condition(_):-
	have(nani),
	nanifound.	
	
list_possessions:-  
	have(X),  
	tab(2),
	write(X),nl,
	fail. 
list_possessions. 
		
	
do(goto(X)):-goto(X),!,fail,nl.
do(nshelp):-nshelp,!,fail,nl. 
do(inventory):-inventory,!,fail,nl. 
do(take(X)):-take(X),!,fail,nl. 
do(drop(X)):-drop(X),!,fail,nl. 
do(eat(X)):-eat(X),!,fail,nl. 
do(look):-look,!,fail,nl. 
do(end). 
do(drink(X)):-drink(X),!,fail,nl.
do(prenderluces(X)):-prenderluces(X),!,fail,nl.
do(apagarluces(X)):-apagarluces(X),!,fail,nl.
do(abrir_puerta(X)):-abrir_puerta(X),!,fail,nl.
do(cerrar_puerta(X)):-cerrar_puerta(X),!,fail,nl.

do(_):-write('Comando Invalido').

%Cuando encuentra a nani
nanifound:-
	have(nani),
	write('FELICIDADES ENCONTRASTE A NANI'), nl,nl.

%darse por vencido
quit:-
	write('No encontraste a Nani. FALLASTE :C').

%El comando que te ayuda
nshelp:-
	write('Usa sentencias simples en Spanish'), nl,
	write('Los comandos que puedes usar:'), nl.
	%write('    go to a room (ex.go to the office)'.
	
	
%notas
nota1:-
	write('Si fueras papá ¿Cuál sería tu lugar favorito?.'), nl,
	write('Pista: Puedes encontrar libros.').

nota:-
	write('Deberías comer algo, ve a la cocina y toma una manzana. No es necesario que la comas'), nl,
	write('Pista: Tal vez ahí encuentres la respuesta'), nl.

%Habitaciones de la casa
room(dormitorio1).
room(dormitorio2).
room(pasillo).
room('baño').
room(cocina).
room(comedor).
room(sala).
room(oficina).
%room([dormitorio1,dormitorio2,pasillo,'baño',cocina,comedor,sala,oficina]).

%Location
%Dormitorio1
location_list(['Cama de Alexia',buro, televisor, closet], dormitorio1).
location_list(['lampara', portaretrato], buro).

%Dormitorio2
location_list(['Cama de papá y mamá', buro2, televisor, closet], dormitorio2).
location_list(['lampara de papá y mamá', portaretrato2], buro2).

%cocina
location_list([tarja,refrigerador,estufa,mesa], cocina).
location_list([manzana,brocoli,'Botella de agua',pera,sopa], mesa).
location_list([soda, botella], refrigerador).
list_edible([manzana,brocoli,sopa]).
list_drink(['Botella de agua',soda, botella]).
tastes_yucky([brocoli]).

%sala
location_list([sofa1, sofa2, 'mesa de centro', televisor, perro], sala).
location_list(['Control de la TV', folleto],'mesa de centro').

%pasillo
location_list(['Buro', 'Lampara', cuadro1], pasillo).
location_list(['Lampara de Mano', llave], 'Buro').

%oficina
location_list([escritorio, silla, librero, 'Lampara de piso', 'Sillon Grande'], oficina).
location_list([libro, agenda, pluma], escritorio).
location_list([nani], 'Sillon Grande').

%comedor
location_list(['Mesa Grande', 'Silla', 'Silla', 'Silla', 'Silla'], comedor).
location_list([velas, platos, utencilios], 'Mesa Grande').

location(X,Y):-
        location_list(Lista, Y),
        miembro(X, Lista).

edible(X):- 
		list_edible(Lista),
		miembro(X,Lista).
	       
drink(X):-
		list_drink(Lista),
		miembro(X,Lista).	 
		
cargar(X):-
		list_cargar(Lista),
		miembro(X,Lista).		

%Conexiones con las habitaciones		
door(baño, pasillo).
door(dormitorio1, pasillo).
door(dormitorio2, pasillo).
door(cocina, pasillo).
door(cocina, comedor).
door(pasillo, sala).
door(comedor, sala).
door(oficina, sala).
door(sala, comedor).

%ambos sentidos
connect(X,Y):- door(X,Y).
connect(X,Y):- door(Y,X).		       

%Cosas que puede cargar nani     
list_cargar(['lampara', portaretrato, manzana, brocoli,sopa, 'Botella de agua', brocoli, soda, 'Control de la TV', folleto,libro, agenda, pluma, nani,velas, platos, utencilios, llave]).        

%lista de cosas en un lugar
list_things(Place):- location(X, Place), tab(2), write(X), nl, location(Y, X), tab(3),
							write('Sobre el(la) '), write(X), write(' esta el(la) '), write(Y), nl,fail.

%lista de lugares que se conectan
list_connections(Place):- connect(Place, X), tab(2), write(X), nl, fail.
list_connections(_).							

%Lo que ve en el lugar que se encuentra
look:-
	here(Place),
	luces(Place, Z),
	Z=off,
	write('No puedes ver nada. Enciende las luces'), nl.
	
look:-
	here(Place),
	write('Tu estas en: '), write(Place), nl, 
	write('Tu puedes ver'), nl, 
	list_things(Place), nl,
	write('Tu puedes ir '), nl,
	list_connections(Place).

look.

%Estados de las puertas
estado(baño, pasillo, off).
estado(pasillo, baño, off).
estado(dormitorio1, pasillo, off).
estado(pasillo, dormitorio1, off).
estado(dormitorio2, pasillo, off).
estado(pasillo, dormitorio2, off).
estado(cocina, pasillo, off).
estado(pasillo, cocina, off).
estado(cocina, comedor, off).
estado(comedor, cocina, off).
estado(oficina, sala, off).
estado(sala, oficina, off).
estado(sala, pasillo, on).
estado(pasillo, sala, on).
estado(sala, comedor, on).
estado(comedor, sala, on).

%luces apagadas
luces(baño, off).
luces(pasillo, off).
luces(dormitorio1, off).
luces(dormitorio2, off).
luces(cocina, off).
luces(comedor, off).
luces(sala, off).
luces(oficina, off).

%prender luces
prenderluces(Place):-
	here(Place),
	retract(luces(Place, off)),
	asserta(luces(Place, on)),
	write('Luces Prendidas'), nl,
	look.

prenderluces(Place):-
	write('No estas en el lugar.'), nl, fail.	

%apagar luces
apagarluces(Place):-
	here(Place),
	retract(luces(Place, on)),
	asserta(luces(Place, off)),
	write('Luces Apagadas').
	
apagarluces(Place):-
	write('No estas en el lugar.'),nl,fail.

here(oficina).

%Verifica si la puerta esta abierta
verificar_puerta(Place):-
	here(X),
	estado(X, Place, Z),
	Z=on,
	write('Puerta abierta'), nl.
	
%Verifica si la puerta esta abierta	
verificar_puerta(Place):-
	write('La puerta para ir a '), write(Place), write(' esta cerrada'), nl, fail.
	
abrir_puerta(Place):-
	Place=oficina,
	not(have(llave)),
	write('Necesitas la llave'),nl.	

%abrir una puerta
abrir_puerta(Place):-
	here(X),
	retract(estado(X, Place, off)),
	asserta(estado(X, Place, on)),
	write('Puerta abierta '),nl.

%cerrar una puerta
cerrar_puerta(Place):-
	here(X),
	retract(estado(X, Place, on)),
	asserta(estado(X, Place, off)),
	write('Puerta cerrada'), nl, fail.	

%VA a un lugar en especifico	
goto(Place):-
	can_go(Place),
	move(Place),
	look, nl.
		
can_go(Place):-
	here(X),
	connect(X,Place),
	verificar_puerta(Place).	
	
can_go(Place):-
	write('El sitio te queda muy lejos'), nl, fail.
	
move(Place):-
	retract(here(X)),
	asserta(here(Place)).

take(X):-
	X=nani,
	can_take(X),
	cargar(X),
	take_object(X),
	nanifound.
	
take(X):-
	X=llave,
	can_take(X),
	cargar(X),
	take_object(X),
	nota.
	
take(X):-
	X=manzana,
	can_take(X),
	cargar(X),
	take_object(X),
	nota1.			

take(X):- 
	can_take(X),
	cargar(X),
	take_object(X).	
	
can_take(X):-
	here(Y),
	is_contained_in(X, Y).

can_take(X):-
	cargar(X),
	write('Objeto no existe'), nl, fail.
	
can_take(X):-
	not(cargar(X)),
	write('El objeto no lo puedes cargar'),nl, fail.

take_object(X):-
	here(Y),
	quitar_objeto(X),
	asserta(have(X)),
	write('Objeto tomado'), nl.
	
quitar_objeto(X):-
	here(Y),
	location_list(Lista, _),
   miembro(X, Lista),
   eliminar(X, Lista, Zs),
   _=A,
   retract(location_list(Lista, A)),
   asserta(location_list(Zs,A)).
	
eliminar(_, [], []).

eliminar(Y, [Y|Xs], Zs):-
          eliminar(Y, Xs, Zs), !.

eliminar(X, [Y|Xs], [Y|Zs]):-
          eliminar(X, Xs, Zs).	
          
insertaFinal(X,L,Z) :- L=[], Z is [X].
insertaFinal(X,[L|Lr],Z) :- insertaFinal(X,Lr,Z1), Z is [L|Z1].

%X es el elemento a insertar al final, L es la lista y Z es la nueva lista con el elemento X al final.

put_thing(Thing,Place):-
	retract(location_list(List,Place)),
	asserta(location_list([Thing|List],Place)).
	
drop(X):-
	have(X),
	here(Y),
	retract(have(X)),
	put_thing(X,Y),
	write('Elemento soltado'),nl.
	
drop(X):-
	write('Objeto no lo tiene'), fail.

inventory:-
	have(X),
	write(X),
	nl,
	fail.
	
inventory:-
	not(have(X)),
	write('no tienes nada').
	
%Lo que se come Alexia
eat(X):-
	have(X),
	edible(X),
	comido(X),
	write('Comiendo manzana'), nl, write('Alexa a comido un(una) ') , write(X), nl.

eat(X):-
	write('No puedes comerte el(la)' ), write(X), write('. No la tienes o no es comestible'), nl.
	
eat(X):-
	write('Terminado'), fail.
	
comido(X):-
	have(X),
	retract(have(X)),
	asserta(put_thing(X, mesa)).	
	
is_contained_in(T1,T2):-
	location(T1,T2).	
	
is_contained_in(T1,T2):-
	location(X,T2),
	is_contained_in(T1,X).		
												
%H=cabeza T=Cola
miembro(H,[H|T]).
miembro(X,[H|T]):-miembro(X,T).