:- consult('database.pl').

%% Transform numeric values into categories for duration
%transform_duration(Number, Category) :-
%    (   Number < 7 -> Category = 'short'
%    ;   Number < 14 -> Category = 'medium'
%    ;   Category = 'long'
%    ).
%
%% Transform numeric values into categories for price
%transform_price(Number, Category) :-
%    (   Number < 1500 -> Category = 'very_low'
%    ;   Number < 3000 -> Category = 'low'
%    ;   Number < 6000 -> Category = 'medium'
%    ;   Number < 10000 -> Category = 'high'
%    ;   Category = 'very_high'
%    ).
% Rule to check if an football_situation satisfies additional conditions.
satisfies_conditions(_, []). % Use _ to indicate an unused variable
satisfies_conditions(ID, [(AttrIndex, Values)|Rest]) :-
    get_attr_value(ID, AttrIndex, AttrValue),
    member(AttrValue, Values),
    satisfies_conditions(ID, Rest).

% Rule to check if two entries differ in the specified attribute and dec while satisfying additional conditions.
diff_attr_dec(ID1, ID2, AttrIndex, Conditions) :-
    get_attr_value(ID1, AttrIndex, AttrValue1),
    get_attr_value(ID2, AttrIndex, AttrValue2),
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
             get_attr_value(ID, AttrIndex, Value)),
            AllValues),
    sort(AllValues, Values).

% Rule to find distinct countries while satisfying conditions
find_distinct_countries(Conditions, Countries) :-
    findall(Dec,
            (football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, Dec),
             satisfies_conditions(ID, Conditions)),
            AllCountries),
    sort(AllCountries, Countries).

% Rule to find entries that satisfy the conditions
find_entries(Conditions, MatchingEntries) :-
    findall((ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
            (football_situation(ID, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18, A19, A20, A21, Dec),
             satisfies_conditions(ID, Conditions)),
            MatchingEntries).

% Recursive loop to find the best matching football_situation
find_matching_trip(MatchingTripID) :-
    attributes(Attributes),
    find_matching_trip_loop(Attributes, [], MatchingTripID).

find_matching_trip_loop([], Conditions, MatchingTripID) :-
    % Base case: No more attributes to check
    find_entries(Conditions, MatchingEntries),
    (   MatchingEntries = [(MatchingTripID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _)|_] ->
        true
    ;   MatchingTripID = 'Trip not found.'
    ).

find_matching_trip_loop(Attributes, Conditions, MatchingTripID) :-
    Attributes \= [],  % Ensure attributes list is not empty
    find_best_attribute(Attributes, Conditions, MaxAttribute),
    select(MaxAttribute, Attributes, RemainingAttributes),
    find_distinct_values(MaxAttribute, Conditions, Values),
    attribute_name(MaxAttribute, AttributeName),
    (   /*MaxAttribute = 1 -> format('Enter duration in days (e.g., 5): ')
    ;   MaxAttribute = 2 -> format('Enter price in PLN (e.g., 2000): ')
    ;   */format('Question: ~w (possible values: ~w): ', [AttributeName, Values])
    ),
    read(UserInput),
    (   /*MaxAttribute = 1 -> (number(UserInput) -> transform_duration(UserInput, TransformedValue) ; TransformedValue = UserInput),
                            NewCondition = (MaxAttribute, [TransformedValue])
    ;   MaxAttribute = 2 -> (number(UserInput) -> transform_price(UserInput, TransformedValue) ; TransformedValue = UserInput),
                            NewCondition = (MaxAttribute, [TransformedValue])
    ;   is_list(UserInput) -> NewCondition = (MaxAttribute, UserInput)
    ;   */NewCondition = (MaxAttribute, [UserInput])
    ),
    append(Conditions, [NewCondition], NewConditions),

    % Check for collisions and inconsistencies
    find_distinct_countries(NewConditions, Countries),
    (   length(Countries, 1) ->
        Countries = [Country],
        MatchingTripID = Country
    ;   find_matching_trip_loop(RemainingAttributes, NewConditions, MatchingTripID)
    ).

% Find the best attribute that maximizes the difference in attribute values
find_best_attribute(Attributes, Conditions, MaxAttribute) :-
    findall(PairsCount-Attr,
            (member(Attr, Attributes),
             count_diff_attr_dec(Attr, Conditions, PairsCount)),
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-MaxAttribute|_]).
