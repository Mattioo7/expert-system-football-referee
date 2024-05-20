:- consult('db.pl').

main :-
    show_welcome_message,
    get_options,
    choose_option.

option(1, print_rules, 'Pokaz wszystkie zasady').
option(2, show_rules, 'Pokaz warunki zasady').
option(3, add_rule, 'Dodaj nowa zasade').
option(4, delete_rule, 'Usun zasade').
option(5, edit_conditions, 'Edytuj warunki zasady').
option(6, save_database, 'Zapisz zmiany').
option(7, exit_program, 'Zakoncz').

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

get_options :-
    option(Number, _, Name),
    format('~p - ~s~n', [Number, Name]),
    fail.
get_options :- !.

choose_option :-
    write('Wybierz opcje: '),
    read(Option),
    option(Option, Action, _),
    Action,
    check_if_exit(Action).

exit_program.

check_if_exit(exit_program) :-
    !.
check_if_exit(_) :-
    main.

print_rules :- 
    football_decision(Id, Decision),
    print_rule(Id, Decision),
    fail.
print_rules :- !.

print_rule(Id, Decision) :-
    format('Zasada ~w: ~w~n', [Id, Decision]).
print_rule :- !.

show_rules :-
    write('Podaj numer zasady: '),
    read(Id),
    print_rule_name(Id),
    print_rule_attributes(Id),
    fail.
show_rules :- !.

print_rule_name(Id) :-
    football_decision(Id, Decision),
    print_rule(Id, Decision).

print_rule_attributes(Id) :-
    football_feature(Id, Feature, Value),
    format('  ~w: ~w~n', [Feature, Value]),
    fail.

add_rule :- !.
delete_rule :- !.
edit_conditions :- !.
save_database :- !.
