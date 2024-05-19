% Mapping string values to fuzzy membership factors

map_foul_severity('lekki', 0.2).
map_foul_severity('przecietny', 0.5).
map_foul_severity('ostry', 0.8).

map_foul_location('glowa', 0.1).
map_foul_location('korpus', 0.5).
map_foul_location('nogi', 0.9).

% Fuzzy membership functions for foul severity

light_foul(Severity, Factor) :-
    (number(Severity), Severity =< 0.3 -> Factor is Severity / 0.3;
     number(Severity), Severity > 0.3 -> Factor is (0.5 - Severity) / 0.2).

average_foul(Severity, Factor) :-
    (number(Severity), Severity =< 0.3 -> Factor is 0;
     number(Severity), Severity > 0.3, Severity =< 0.7 -> Factor is (Severity - 0.3) / 0.4;
     number(Severity), Severity > 0.7 -> Factor is (0.9 - Severity) / 0.2).

hard_foul(Severity, Factor) :-
    (number(Severity), Severity =< 0.5 -> Factor is 0;
     number(Severity), Severity > 0.5, Severity =< 0.9 -> Factor is (Severity - 0.5) / 0.4;
     number(Severity), Severity > 0.9 -> Factor is 1).

% Fuzzy membership functions for foul location

head_foul(Location, Factor) :-
    (number(Location), Location =< 0.2 -> Factor is Location / 0.2;
     number(Location), Location > 0.2 -> Factor is (0.4 - Location) / 0.2).

body_foul(Location, Factor) :-
    (number(Location), Location =< 0.4 -> Factor is 0;
     number(Location), Location > 0.4, Location =< 0.6 -> Factor is (Location - 0.4) / 0.2;
     number(Location), Location > 0.6 -> Factor is (0.8 - Location) / 0.2).

leg_foul(Location, Factor) :-
    (number(Location), Location =< 0.6 -> Factor is 0;
     number(Location), Location > 0.6, Location =< 1 -> Factor is (Location - 0.6) / 0.4).

% Defuzzification using the centroid method

defuzzy_center(Factors, FactorValues, Result) :-
    sum_vector_2(Factors, FactorValues, Top),
    sum_vector(Factors, Bottom),
    (Bottom == 0 -> Result is 0; Result is Top / Bottom).

sum_vector([], 0).
sum_vector([H|T], Sum) :-
    sum_vector(T, R),
    Sum is H + R.

sum_vector_2([], [], 0).
sum_vector_2([H_L|T_L], [H_R|T_R], P) :- 
    sum_vector_2(T_L, T_R, R), 
    P is (H_L * H_R) + R.

% Evaluating the severity factor

evaluate_foul_severity(String, Severity, Factor) :-
    map_foul_severity(String, Factor1),
    foul_severity_factor(Severity, Factor2),
    Factor is 1 - abs(Factor1 - Factor2).

foul_severity_factor(Severity, Factor) :-
    light_foul(Severity, F1),
    average_foul(Severity, F2),
    hard_foul(Severity, F3),
    map_foul_severity('lekki', M1),
    map_foul_severity('przecietny', M2),
    map_foul_severity('ostry', M3),
    defuzzy_center([F1, F2, F3], [M1, M2, M3], Factor).

% Evaluating the location factor

evaluate_foul_location(String, Location, Factor) :-
    map_foul_location(String, Factor1),
    foul_location_factor(Location, Factor2),
    Factor is 1 - abs(Factor1 - Factor2).

foul_location_factor(Location, Factor) :-
    head_foul(Location, F1),
    body_foul(Location, F2),
    leg_foul(Location, F3),
    map_foul_location('glowa', M1),
    map_foul_location('korpus', M2),
    map_foul_location('nogi', M3),
    defuzzy_center([F1, F2, F3], [M1, M2, M3], Factor).

% Example of how to use these functions
% calculate_foul(SeverityString, LocationString, SeverityValue, LocationValue, SeverityFactor, LocationFactor) :-
%    evaluate_foul_severity(SeverityString, SeverityValue, SeverityFactor),
%    evaluate_foul_location(LocationString, LocationValue, LocationFactor).




