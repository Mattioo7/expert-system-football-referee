:- consult('reasoning.pl').

% Start the process
main :-
    find_matching_trip(MatchingTripID),
    (   MatchingTripID = 'Trip not found.' ->
        format('Matching trip: ~w~n', [MatchingTripID])
    ;   format('Matching trip country: ~w~n', [MatchingTripID])
    ).