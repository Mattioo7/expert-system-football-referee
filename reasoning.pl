:- consult('database.pl').
:- consult('attributes_helper.pl').

% Main function to start the decision-making process
football_referee(Decision) :-
    question_number(QuestionNumber),
    make_decision(QuestionNumber, [], Decision).

% Recursive loop to make a decision based on the conditions and attributes
make_decision([], Conditions, Decision) :-
    find_matching_situations(Conditions, MatchingEntries),
    (   MatchingEntries = [(Decision, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _)|_] ->
        true
    ;   Decision = 'Nie mozna podjąć decyzji'
    ).

% Updated make_decision predicate
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
    format('Pytanie: ~w [Odp: ~w]: ', [AttributeName, Values]),
    read(UserInput),
    NewCondition = (BestAttribute, [UserInput]),
    append(Conditions, [NewCondition], NewConditions).

satisfies_conditions(_, []).
satisfies_conditions(ID, [(AttrIndex, Values)|Rest]) :-
    get_answer(ID, AttrIndex, AttrValue),
    member(AttrValue, Values),
    satisfies_conditions(ID, Rest).

% Rule to check if two entries differ in the specified attribute and decision while satisfying additional conditions.
differs_in_attribute_and_decision(ID1, ID2, AttrIndex, Conditions) :-
    get_answer(ID1, AttrIndex, AttrValue1),
    get_answer(ID2, AttrIndex, AttrValue2),
    football_situation(ID1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec1),
    football_situation(ID2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec2),
    AttrValue1 \= AttrValue2,
    Dec1 \= Dec2,
    satisfies_conditions(ID1, Conditions),
    satisfies_conditions(ID2, Conditions).

% Rule to count the number of pairs that differ in the specified attribute and decision while satisfying additional conditions.
count_differing_pairs(AttrIndex, Conditions, PairsCount) :-
    findall((ID1, ID2),
            (football_situation(ID1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             football_situation(ID2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             ID1 < ID2,
             differs_in_attribute_and_decision(ID1, ID2, AttrIndex, Conditions)),
            Pairs),
    length(Pairs, PairsCount).

% Rule to find distinct values for a specific attribute while satisfying conditions
get_distinct_values(AttrIndex, Conditions, Values) :-
    findall(Value,
            (football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             satisfies_conditions(ID, Conditions),
             get_answer(ID, AttrIndex, Value)),
            AllValues),
    sort(AllValues, Values).

% Rule to find distinct decisions while satisfying conditions
get_distinct_decisions(Conditions, Decisions) :-
    findall(Dec,
            (football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec),
             satisfies_conditions(ID, Conditions)),
            AllDecisions),
    sort(AllDecisions, Decisions).

% Rule to find entries that satisfy the conditions
find_matching_situations(Conditions, MatchingEntries) :-
    findall((ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
            (football_situation(ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
             satisfies_conditions(ID, Conditions)),
            MatchingEntries).

% Find the best attribute that maximizes the difference in attribute values
find_optimal_attribute(Attributes, Conditions, BestAttribute) :-
    findall(PairsCount-Attr,
            (member(Attr, Attributes),
             count_differing_pairs(Attr, Conditions, PairsCount)),
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-BestAttribute|_]).
