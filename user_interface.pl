:- consult('reasoning.pl').

% Start the process
main :-
    find_matching_football_situation(MatchingEntry),
    last_element(MatchingEntry, LastAttribute),
    format('Last attribute of matching football_situation: ~w~n', [LastAttribute]).

% Helper predicate to find the last element of a list
last_element([X], X).
last_element([_|Xs], Last) :-
    last_element(Xs, Last).
