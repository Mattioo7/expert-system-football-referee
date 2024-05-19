:- consult('reasoning.pl').

main :-
    show_welcome_message,
    sleep(0),
    show_instructions,
    sleep(0),
    football_referee(Decision),
    show_analysis_message,
    sleep(1),
    show_analysis_message,
    sleep(1),
    nl,
    format('Podjęta decyzja: ~w~n', [Decision]).

show_welcome_message :-
    nl,
    write('****************************************'), nl,
    write('*                                      *'), nl,
    write('*  Witaj w systemie                    *'), nl,
    write('*  Pomocny Inteligentny Likwidator     *'), nl,
    write('*  Kontrowersji Arbitrów (PILKA)!      *'), nl,
    write('*                                      *'), nl,
    write('****************************************'), nl,
    nl.

show_instructions :-
    write('Instrukcja użytkowania:'), nl,
    write('1. Przekaż informacje o sytuacji boiskowej, wybierając jedną z dostępnych opcji.'), nl,
    write('2. System przeanalizuje dane.'), nl,
    write('3. Poczekaj na decyzję, która zostanie wyświetlona na ekranie.'), nl,
    nl,
    write('Uwaga: Każda linia musi kończyć się kropką.'), nl,
    nl,
    write('****************************************'), nl, nl.

show_analysis_message :-
    write('Analizowanie sytuacji...'), nl.
