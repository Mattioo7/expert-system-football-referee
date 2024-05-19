% Mapping string values to fuzzy membership factors

map_foul_severity('lekki', 1).
map_foul_severity('przecietny', 5).
map_foul_severity('ostry', 9).

map_foul_location('glowa', 1).
map_foul_location('korpus', 5).
map_foul_location('nogi', 9).

% Fuzzy membership functions for foul severity

light_foul(Severity, Factor) :-
    (number(Severity), Severity =< 2 -> Factor is 10;
     number(Severity), Severity > 2, Severity =< 4 -> Factor is 6;
     number(Severity), Severity > 4, Severity =< 6 -> Factor is 4;
     number(Severity), Severity > 6 -> Factor is 0).

average_foul(Severity, Factor) :-
    (number(Severity), Severity =< 4 -> Factor is 0;
     number(Severity), Severity > 4, Severity =< 6 -> Factor is 10;
     number(Severity), Severity > 6 -> Factor is 0).

hard_foul(Severity, Factor) :-
    (number(Severity), Severity =< 4 -> Factor is 0;
     number(Severity), Severity > 4, Severity =< 6 -> Factor is 3;
     number(Severity), Severity > 6, Severity =< 7 -> Factor is 7;
     number(Severity), Severity > 7 -> Factor is 10).

% Fuzzy membership functions for foul location

head_foul(Location, Factor) :-
    (number(Location), Location =< 2 -> Factor is 10;
     number(Severity), Severity > 4, Severity =< 5 -> Factor is 9;
     number(Severity), Severity > 5, Severity =< 6 -> Factor is 6;
     number(Location), Location > 2 -> Factor is 0).

body_foul(Location, Factor) :-
    (number(Location), Location =< 4 -> Factor is 0;
     number(Location), Location > 4, Location =< 6 -> Factor is 10;
     number(Location), Location > 6 -> Factor is 0).

leg_foul(Location, Factor) :-
    (number(Location), Location =< 4 -> Factor is 0;
     number(Severity), Severity > 4, Severity =< 5 -> Factor is 7;
     number(Severity), Severity > 5, Severity =< 7 -> Factor is 8;
     number(Location), Location > 7 -> Factor is 10).

% Defuzzification using the centroid method

defuzzy_center(Factors, FactorValues, Result) :-
    sum_vector_2(Factors, FactorValues, Top),
    sum_vector(Factors, Bottom),
    (member(Bottom, [0, 0.0]) -> Result is 0 ; Result is Top / Bottom).

sum_vector([], 0).
sum_vector([H|T], Sum) :-
    sum_vector(T, R),
    Sum is H + R.

sum_vector_2([], [], 0).
sum_vector_2([H_L|T_L], [H_R|T_R], P) :-
    sum_vector_2(T_L, T_R, R),
    P is (H_L * H_R) + R.

% Evaluating the severity factor

evaluate_foul_severity(Severity, Factor) :-
    foul_severity_factor(Severity, Factor2),
    foul_degree(Factor2, Factor).

foul_severity_factor(Severity, Factor) :-
    light_foul(Severity, F1),
    average_foul(Severity, F2),
    hard_foul(Severity, F3),
    map_foul_severity('lekki', M1),
    map_foul_severity('przecietny', M2),
    map_foul_severity('ostry', M3),
    defuzzy_center([F1, F2, F3], [M1, M2, M3], Factor).

% Evaluating the location factor

evaluate_foul_location(Location, Factor) :-
    foul_location_factor(Location, Factor2),
    foul_location(Factor2, Factor).

foul_location_factor(Location, Factor) :-
    head_foul(Location, F1),
    body_foul(Location, F2),
    leg_foul(Location, F3),
    map_foul_location('glowa', M1),
    map_foul_location('korpus', M2),
    map_foul_location('nogi', M3),
    defuzzy_center([F1, F2, F3], [M1, M2, M3], Factor).

foul_degree(Severity, Degree) :-
    (Severity =< 3 -> Degree = 'lekki';
     Severity > 3, Severity =< 7 -> Degree = 'przecietny';
     Severity > 7 -> Degree = 'ostry').

foul_location(Severity, Degree) :-
    (Severity =< 3 -> Degree = 'nogi';
     Severity > 3, Severity =< 7 -> Degree = 'korpus';
     Severity > 7 -> Degree = 'glowa').
