:- consult('database.pl').

% Rule to check if an football_situation satisfies additional conditions.
satisfies_conditions(_, []). % Use _ to indicate an unused variable
satisfies_conditions(ID, [(AttrIndex, Value)|Rest]) :-
    get_attr_value(ID, AttrIndex, AttrValue),
    AttrValue = Value,
    satisfies_conditions(ID, Rest).

% Rule to check if two entries differ in the specified attribute and dec while satisfying additional conditions.
diff_attr_dec(ID1, ID2, AttrIndex, Conditions) :-
    get_attr_value(ID1, AttrIndex, AttrValue1),
    get_attr_value(ID2, AttrIndex, AttrValue2),
    football_situation(ID1, _, _, _, _, _, Dec1),
    football_situation(ID2, _, _, _, _, _, Dec2),
    AttrValue1 \= AttrValue2,
    Dec1 \= Dec2,
    satisfies_conditions(ID1, Conditions),
    satisfies_conditions(ID2, Conditions).

% Rule to count the number of pairs that differ in the specified attribute and dec while satisfying additional conditions.
count_diff_attr_dec(AttrIndex, Conditions, PairsCount) :-
    findall((ID1, ID2),
            (football_situation(ID1, _, _, _, _, _, _),
             football_situation(ID2, _, _, _, _, _, _),
             ID1 < ID2,
             diff_attr_dec(ID1, ID2, AttrIndex, Conditions)),
            Pairs),
    length(Pairs, PairsCount).

% Rule to find distinct values for a specific attribute while satisfying conditions
find_distinct_values(AttrIndex, Conditions, Values) :-
    findall(Value,
            (football_situation(ID, _, _, _, _, _, _),
             satisfies_conditions(ID, Conditions),
             get_attr_value(ID, AttrIndex, Value)),
            AllValues),
    sort(AllValues, Values).

% Rule to find entries that satisfy the conditions
find_entries(Conditions, MatchingEntries) :-
    findall((ID, A1, A2, A3, A4, A5, Dec),
            (football_situation(ID, A1, A2, A3, A4, A5, Dec),
             satisfies_conditions(ID, Conditions)),
            MatchingEntries).

% Recursive loop to find the best matching football_situation
find_matching_football_situation(Matchingfootball_situation) :-
    attributes(Attributes),
    find_matching_football_situation_loop(Attributes, [], Matchingfootball_situation).

find_matching_football_situation_loop([], Conditions, Matchingfootball_situation) :-
    % Base case: No more attributes to check
    find_entries(Conditions, MatchingEntries),
    (   MatchingEntries = [Matchingfootball_situation|_] ->
        true
    ;   Matchingfootball_situation = 'No unique matching football_situation found'
    ).

find_matching_football_situation_loop(Attributes, Conditions, Matchingfootball_situation) :-
    Attributes \= [],  % Ensure attributes list is not empty
    find_best_attribute(Attributes, Conditions, MaxAttribute),
    select(MaxAttribute, Attributes, RemainingAttributes),
    find_distinct_values(MaxAttribute, Conditions, Values),
    attribute_name(MaxAttribute, AttributeName),
    format('~w (possible values: ~w): ', [AttributeName, Values]),
    read(Value),
    NewCondition = (MaxAttribute, Value),
    append(Conditions, [NewCondition], NewConditions),

    % Check for collisions and inconsistencies
    find_entries(NewConditions, MatchingEntries),
    (   length(MatchingEntries, 1) ->
        MatchingEntries = [Matchingfootball_situation]
    ;   find_matching_football_situation_loop(RemainingAttributes, NewConditions, Matchingfootball_situation)
    ).

% Find the best attribute that maximizes the difference in attribute values
find_best_attribute(Attributes, Conditions, MaxAttribute) :-
    findall(PairsCount-Attr,
            (member(Attr, Attributes),
             count_diff_attr_dec(Attr, Conditions, PairsCount)),
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-MaxAttribute|_]).