:- consult('database.pl').
:- consult('attributes_helper.pl').


football_referee(Decision) :-
    question_number(QuestionNumber),
    make_football_referee_decision_loop(QuestionNumber, [], Decision).

make_football_referee_decision_loop([], Conditions, Decision) :-
    find_football_situations(Conditions, MatchingEntries),
    (   MatchingEntries = [(Decision, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _)|_] ->
        true
    ;   Decision = 'Nie mozna podjąć decyzji'
    ).

make_football_referee_decision_loop(Attributes, Conditions, Decision) :-
    Attributes \= [],
    find_best_attribute(Attributes, Conditions, MaxAttribute),
    select(MaxAttribute, Attributes, RemainingAttributes),
    find_distinct_values(MaxAttribute, Conditions, Values),
    question(MaxAttribute, AttributeName),
    format('Pytanie: ~w [Odp: ~w]: ', [AttributeName, Values]),
    read(UserInput),
    NewCondition = (MaxAttribute, [UserInput]),
    append(Conditions, [NewCondition], NewConditions),

    find_distinct(NewConditions, MatchingEntries),
    (   length(MatchingEntries, 1) ->
        MatchingEntries = [Decision]
    ;   make_football_referee_decision_loop(RemainingAttributes, NewConditions, Decision)
    ).

% Rule to check if an football_situation satisfies additional conditions.
satisfies_conditions(_, []).
satisfies_conditions(ID, [(AttrIndex, Values)|Rest]) :-
    get_answer(ID, AttrIndex, AttrValue),
    member(AttrValue, Values),
    satisfies_conditions(ID, Rest).

% Rule to check if two entries differ in the specified attribute and dec while satisfying additional conditions.
diff_attr_dec(ID1, ID2, AttrIndex, Conditions) :-
    get_answer(ID1, AttrIndex, AttrValue1),
    get_answer(ID2, AttrIndex, AttrValue2),
    football_situation(ID1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec1),
    football_situation(ID2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec2),
    AttrValue1 \= AttrValue2,
    Dec1 \= Dec2,
    satisfies_conditions(ID1, Conditions),
    satisfies_conditions(ID2, Conditions).

% Rule to count the number of pairs that differ in the specified attribute and dec while satisfying additional conditions.
count_diff_attr_dec(AttrIndex, Conditions, PairsCount) :-
    findall((ID1, ID2),
            (football_situation(ID1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             football_situation(ID2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             ID1 < ID2,
             diff_attr_dec(ID1, ID2, AttrIndex, Conditions)),
            Pairs),
    length(Pairs, PairsCount).

% Rule to find distinct values for a specific attribute while satisfying conditions
find_distinct_values(AttrIndex, Conditions, Values) :-
    findall(Value,
            (football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _),
             satisfies_conditions(ID, Conditions),
             get_answer(ID, AttrIndex, Value)),
            AllValues),
    sort(AllValues, Values).

% Rule to find distinct while satisfying conditions
find_distinct(Conditions, Countries) :-
    findall(Dec,
            (football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec),
             satisfies_conditions(ID, Conditions)),
            AllCountries),
    sort(AllCountries, Countries).

% Rule to find entries that satisfy the conditions
find_football_situations(Conditions, MatchingEntries) :-
    findall((ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
            (football_situation(ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
             satisfies_conditions(ID, Conditions)),
            MatchingEntries).

% Find the best attribute that maximizes the difference in attribute values
find_best_attribute(Attributes, Conditions, MaxAttribute) :-
    findall(PairsCount-Attr,
            (member(Attr, Attributes),
             count_diff_attr_dec(Attr, Conditions, PairsCount)),
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-MaxAttribute|_]).
