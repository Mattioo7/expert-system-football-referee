:- consult('db.pl').
:- consult('attributes_helper.pl').
:- consult('fuzzy_reasoning.pl').

football_referee(Decision) :-
    question_number(QuestionNumber),
    make_decision(QuestionNumber, [], Decision).

make_decision([], Conditions, Id) :-
    find_matching_situations(Conditions, MatchingEntries),
    (   MatchingEntries = [(Id)|_] ->
        true
    ;   Id = 'Nie mozna podjąć decyzji'
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

find_optimal_attribute(Attributes, Conditions, BestAttribute) :-
    findall(PairsCount-Attr,
            (member(Attr, Attributes),
             differing_pairs_count(Attr, Conditions, PairsCount)),
            Counts),
    keysort(Counts, SortedCounts),
    reverse(SortedCounts, [_-BestAttribute|_]).

get_distinct_values(ElementIdx, Conditions, Values) :-
    findall(Value,
            (football_feature(ID, _, _),
             meets_criteria(ID, Conditions),
             get_answer(ID, ElementIdx, Value)),
            AllValues),
    sort(AllValues, Values).

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

get_distinct_decisions(Conditions, Decisions) :-
    findall(Dec,
            (football_feature(ID, decision, Dec),
             meets_criteria(ID, Conditions)),
            AllDecisions),
    sort(AllDecisions, Decisions).

meets_criteria(_, []).
meets_criteria(ID, [(ElementIdx, Values)|Rest]) :-
    get_answer(ID, ElementIdx, ElementValue),
    member(ElementValue, Values),
    meets_criteria(ID, Rest).

differing_pairs_count(ElementIdx, Conditions, PairsCount) :-
    findall((ID1, ID2),
            (football_feature(ID1, decision, _),
             football_feature(ID2, decision, _),
             ID1 < ID2,
             differs_in_attribute_and_decision(ID1, ID2, ElementIdx, Conditions)),
            Pairs),
    length(Pairs, PairsCount).

differs_in_attribute_and_decision(ID1, ID2, ElementIdx, Conditions) :-
    get_answer(ID1, ElementIdx, ElementValue1),
    get_answer(ID2, ElementIdx, ElementValue2),
    get_decision_name(ID1, Dec1),
    get_decision_name(ID2, Dec2),
    ElementValue1 \= ElementValue2,
    Dec1 \= Dec2,
    meets_criteria(ID1, Conditions),
    meets_criteria(ID2, Conditions).

find_matching_situations(Conditions, MatchingEntries) :-
    get_unique_rule_ids(UniqueIds),
    get_unique_rules(UniqueIds, MatchingEntries, Conditions).

get_unique_rules([Id|RestIds], Result, Conditions) :-
    meets_criteria(Id, Conditions),   % Check if the ID meets the criteria
    meets_criteria(Id, Conditions),   % Add additional conditions if needed
    get_unique_rules(RestIds, RestResult), % Recurse on the tail of the list
    Result = [Id|RestResult].

get_unique_rules([], [], []).
