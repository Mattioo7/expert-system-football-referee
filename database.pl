% football_situation(ID, ball out?, which line?, pass?, was offside?, which team?, DECISION).
football_situation(1, 'yes', 'goal_line', _, 'A', 'team1', 'goal').
football_situation(2, 'yes',         'B', _, 'B', 'team1', 'goal').
football_situation(5, 'no',            _, _,   _, 'team3', 'offside3').

% Rule to get the attribute value by index.
get_attr_value(ID, 1, A1) :- football_situation(ID, A1, _, _, _, _, _).
get_attr_value(ID, 2, A2) :- football_situation(ID, _, A2, _, _, _, _).
get_attr_value(ID, 3, A3) :- football_situation(ID, _, _, A3, _, _, _).
get_attr_value(ID, 4, A4) :- football_situation(ID, _, _, _, A4, _, _).
get_attr_value(ID, 5, A5) :- football_situation(ID, _, _, _, _, A5, _).

% Rule to get the decision by ID
get_decision(ID, Decision) :- football_situation(ID, _, _, _, _, _, Decision).

% Rule to get the attribute name based on index
attribute_name(1, 'Ball out?').
attribute_name(2, 'Which line?').
attribute_name(3, 'Wass pass?').
attribute_name(4, 'Was offside?').
attribute_name(5, 'Which team?').

% Initial attributes
attributes([1, 2, 3, 4, 5]).
