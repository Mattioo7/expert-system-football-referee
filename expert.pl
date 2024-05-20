:- consult('db.pl').

main :-
    show_welcome_message,
    get_options,
    choose_option.

option(0, print_decisions, 'Pokaz wszystkie decyzje').
option(1, print_rules, 'Pokaz wszystkie zasady').
option(2, show_rules, 'Pokaz warunki zasady').
option(3, add_rule, 'Dodaj nowa zasade').
option(4, delete_rule, 'Usun zasade').
option(5, edit_conditions, 'Edytuj warunki zasady').
option(6, add_decision, 'Dodaj nowa decyzje').
option(7, save_database, 'Zapisz zmiany').
option(8, exit_program, 'Zakoncz').

show_welcome_message :-
    nl,
    write('****************************************'), nl,
    write('*                                      *'), nl,
    write('*  Witaj w systemie eksperckim         *'), nl,
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
    football_feature(Id, decision, Name),
    print_rule(Id, Name),
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
    football_feature(Id, decision, Decision),
    print_rule(Id, Decision).

print_rule_attributes(Id) :-
    football_feature(Id, Feature, Value),
    format('  ~w: ~w~n', [Feature, Value]),
    fail.

add_rule :-
    print_all_decision_ids,
    write('Podaj decyzje dla zasady: '),
    read(DecisionId),
    football_decision(DecisionId, _),
    max_id(Id),
    NewId is Id + 1,
    assert(football_feature(NewId, decision, DecisionId)),
    add_blank_conditions(NewId),
    format('Dodano zasade ~w: ~w~n', [NewId, DecisionId]).
add_rule :- unknown_error.

add_blank_conditions(Id) :-
    findall(FeatureId, football_feature(_, FeatureId, _), FeatureIds),
    subtract(FeatureIds, [decision], FeatureIdsWithoutDecision),
    sort(FeatureIdsWithoutDecision, FeatureIdsDistinct),
    add_blank_conditions(Id, FeatureIdsDistinct).

add_blank_conditions(Id, [FeatureId|Rest]) :-
    assert(football_feature(Id, FeatureId, brak)),
    add_blank_conditions(Id, Rest).
add_blank_conditions(_, []).

delete_rule :-
    write('Podaj numer zasady: '),
    read(Id),
    retractall(football_feature(Id, _, _)),
    format('Usunieto zasade ~w~n', [Id]).
delete_rule :- unknown_error.

edit_conditions :- 
    write('Podaj numer zasady: '),
    read(Id),
    football_feature(Id, decision, _),
    print_all_feature_ids,
    write('Podaj nazwe cechy: '),
    read(FeatureId),
    football_feature(_, FeatureId, _),
    edit_conditions(Id, FeatureId).
edit_conditions :- unknown_error.

edit_conditions(Id, FeatureId) :-
    print_all_values_for_feature(FeatureId),
    write('Podaj wartosc: '),
    read(Value),
    football_feature(_, FeatureId, Value),
    assert(football_feature(Id, FeatureId, Value)),
    format('Zmieniono wartosc cechy ~w na ~w~n', [FeatureId, Value]).

save_database :-
    tell('db.pl'),
    listing(football_decision),
    listing(football_feature),
    told,
    write('Zapisano zmiany w bazie danych!'), nl.

save_database :- unknown_error.

add_decision :-
    write('Podaj opis nowej decyzji (musi byc w apostrofach): '),
    read(Decision),
    write('Podaj identyfikator decyzji: '),
    read(Id),
    assert(football_decision(Id, Decision)),
    format('Dodano decyzje ~w: ~w~n', [Id, Decision]).
add_decision :- unknown_error.

% Helpers:

print_decisions :-
    football_decision(Id, Decision),
    format('~w: ~w~n', [Id, Decision]),
    fail.
print_decisions :- !.


print_all_decision_ids :-
    findall(Id, football_decision(Id, _), Ids),
    sort(Ids, IdsDistinct),
    atomic_list_concat(IdsDistinct, ', ', IdsString),
    format('Dostepne decyzje: ~w~n', [IdsString]).

print_all_feature_ids :-
    findall(Name, football_feature(_, Name, _), Names),
    sort(Names, NamesDistinct),
    atomic_list_concat(NamesDistinct, ', ', NamesString),
    format('Dostepne cechy: ~w~n', [NamesString]).

print_all_values_for_feature(FeatureId) :-
    findall(Value, football_feature(_, FeatureId, Value), Values),
    sort(Values, ValuesDistinct),
    atomic_list_concat(ValuesDistinct, ', ', ValuesString),
    format('Dostepne wartosci: ~w~n', [ValuesString]).

unknown_error :-
    write('Nieznany blad, prawdopodobnie podano zla opcje!'), nl.

collect_ids(Ids) :-
    findall(Id, football_feature(Id, decision, _), Ids).

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
