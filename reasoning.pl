:- consult('database.pl').
:- consult('attributes_helper.pl').
:- consult('fuzzy_reasoning.pl').

football_referee(Decision) :-
    question_number(QuestionNumber),
    make_decision(QuestionNumber, [], Decision).

make_decision([], Conditions, Decision) :-
    find_matching_situations(Conditions, MatchingEntries),
    (   MatchingEntries = [(Decision, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _)|_] ->
        true
    ;   Decision = 'Nie mozna podjąć decyzji'
    ).

make_decision(Attributes, Conditions, Decision) :-
    Attributes \= [],
    find_optimal_attribute(Attributes, Conditions, BestAttribute),
    select(BestAttribute, Attributes, RemainingAttributes),
    get_distinct_values(BestAttribute, Conditions, Values),

    ask_user_for_input(BestAttribute, Values, Conditions, NewConditions),

    get_distinct_decisions(NewConditions, MatchingEntries),
    (   length(MatchingEntries, 1) ->
        MatchingEntries = [Decision]
    ;   make_decision(RemainingAttributes, NewConditions, Decision)
    ).

ask_user_for_input(BestAttribute, Values, Conditions, NewConditions) :-
    question(BestAttribute, AttributeName),
    (   BestAttribute = 9 -> format(' 9 Dynamika faulu? (w skali od 1 - lekki do 10 - bardz ostry): ')
    ;   BestAttribute = 10 -> format('10 Gdzie został gracz dotknięty? (w skali od 1 - miejsce mało wrażliwe do 10 - miejsce bardzo wrażliwe): ')
    ;   format('Question: ~w (possible values: ~w): ', [AttributeName, Values])
    ),
    read(UserInput),
    (   BestAttribute = 9 -> (number(UserInput) -> evaluate_foul_severity(UserInput, TransformedValue); TransformedValue = UserInput),
                            NewCondition = (BestAttribute, [TransformedValue])
    ;   BestAttribute = 10 -> (number(UserInput) -> evaluate_foul_location(UserInput, TransformedValue) ; TransformedValue = UserInput),
                            NewCondition = (BestAttribute, [TransformedValue])
    ;   NewCondition = (BestAttribute, [UserInput])
    ),
    append(Conditions, [NewCondition], NewConditions).

meets_criteria(_, []).
meets_criteria(ID, [(ElementIdx, Values)|Rest]) :-
    get_answer(ID, ElementIdx, ElementValue),
    member(ElementValue, Values),
    meets_criteria(ID, Rest).

differs_in_attribute_and_decision(ID1, ID2, ElementIdx, Conditions) :-
    get_answer(ID1, ElementIdx, ElementValue1),
    get_answer(ID2, ElementIdx, ElementValue2),
    football_situation(ID1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec1),
    football_situation(ID2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec2),
    ElementValue1 \= ElementValue2,
    Dec1 \= Dec2,
    meets_criteria(ID1, Conditions),
    meets_criteria(ID2, Conditions).

differing_pairs_count(ElementIdx, Conditions, PairsCount) :-
    findall((ID1, ID2),
            (football_situation(ID1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             football_situation(ID2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             ID1 < ID2,
             differs_in_attribute_and_decision(ID1, ID2, ElementIdx, Conditions)),
            Pairs),
    length(Pairs, PairsCount).

get_distinct_values(ElementIdx, Conditions, Values) :-
    findall(Value,
            (football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             meets_criteria(ID, Conditions),
             get_answer(ID, ElementIdx, Value)),
            AllValues),
    sort(AllValues, Values).

get_distinct_decisions(Conditions, Decisions) :-
    findall(Dec,
            (football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec),
             meets_criteria(ID, Conditions)),
            AllDecisions),
    sort(AllDecisions, Decisions).

find_matching_situations(Conditions, MatchingEntries) :-
    findall((ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
            (football_situation(ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
             meets_criteria(ID, Conditions)),
            MatchingEntries).

find_optimal_attribute(Attributes, Conditions, BestAttribute) :-
    findall(PairsCount-Attr,
            (member(Attr, Attributes),
             differing_pairs_count(Attr, Conditions, PairsCount)),
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-BestAttribute|_]).
