:- consult('reasoning.pl').

% Start the process
main :-
    find_matching_football_situation(MatchingEntry),
    format('Matching football_situation: ~w~n', [MatchingEntry]).