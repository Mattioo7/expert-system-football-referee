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

add_rule :-
    write('Podaj decyzje (zamknieta w apostrofy): '),
    read(Decision),
    max_id(Id),
    NewId is Id + 1,
    assert(football_decision(NewId, Decision)),
    format('Dodano zasade ~w: ~w~n', [NewId, Decision]).
add_rule :- unknown_error.

delete_rule :-
    write('Podaj numer zasady: '),
    read(Id),
    retract(football_decision(Id, _)),
    retractall(football_feature(Id, _, _)),
    format('Usunieto zasade ~w~n', [Id]).
delete_rule :- unknown_error.

edit_conditions :- 
    write('Podaj numer zasady: '),
    read(Id),
    edit_conditions(Id),
    save_database.
edit_conditions :- unknown_error.

edit_conditions(Id) :-
    !.

save_database :-
    tell('db.pl'),
    listing(football_decision),
    listing(football_feature),
    told,
    write('Zapisano zmiany w bazie danych!'), nl.

save_database :- unknown_error.

% Helpers:

unknown_error :-
    write('Nieznany blad!'), nl.

collect_ids(Ids) :-
    findall(Id, football_decision(Id, _), Ids).

max_id(MaxId) :-
    collect_ids(Ids),
    max_list(Ids, MaxId).

max_list([Head|Tail], Max) :-
    max_list(Tail, Head, Max).

max_list([], Max, Max).

max_list([Head|Tail], CurrentMax, Max) :-
    Head > CurrentMax,
    max_list(Tail, Head, Max).

max_list([Head|Tail], CurrentMax, Max) :-
    Head =< CurrentMax,
    max_list(Tail, CurrentMax, Max).
