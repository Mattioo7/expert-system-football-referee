question_number([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]).

question( 1, ' 1.   Co sie stalo?').
question( 2, ' 2.   Za jaka linie wypadla pilka?').
question( 3, ' 3.   Linia koncowa na połowie ktorej druzyny?').
question( 4, ' 4.   Zawodnik, której drużyny dotknął ostatni?').
question( 5, ' 5.   Czy podanie za linią obrony?').
question( 6, ' 6.   Adresat podania jest dalej od bramki przeciwnika niż obrońcy drużyny przeciwnej?').
question( 7, ' 7.   Która dużyna wykonała podanie?').
question( 8, ' 8.   Czy kontakt graczy zgodny z przepisami?').
question( 9, ' 9.   Dynamika faulu?').
question(10, '10.   Gdzie został gracz dotknięty?').
question(11, '11.   Gdzie nastąpił (faul/zajście) ?').
question(12, '12.   Kto przekroczył przepisy?').
question(13, '13.   W czyjej bramce?').
question(14, '14.   Gdzie (dotknięto ręką)?').
question(15, '15.   Kto doknął (ręką)?').
question(16, '16.   Czy powstrzymał akcję (przez rękę)?').
question(17, '17.   Kto jest osobą 1 (w rozmowie)?').
question(18, '18.   Kto jest osobą 2 (w rozmowie)?').
question(19, '19.   Czy obelgi?').
question(20, '20.   Kto obraził jako pierwszy?').
question(21, '21.   Czy ma już żółtą kartkę?').

football_variable_names(what_happened, ball_out_line, end_line_side, last_touch_team, pass_offside, pass_receiver_position, passing_team, legal_contact, foul_dynamics, player_touched_location, foul_location, rule_breaker, goal_side, hand_touch_location, hand_touch_player, hand_stopped_play, person_1, person_2, insults, first_insult, yellow_card_status).

get_unique_rule_ids(UniqueIds) :-
    findall(Id, football_feature(Id, _, _), Ids),
    sort(Ids, UniqueIds).

get_decision_name(Id, Name) :-
    football_feature(Id, decision, DecisionName),
    football_decision(DecisionName, Name).

get_answer(Id, Index, Value) :-
    get_key(Index, Key),
    football_feature(Id, Key, Value).

get_key(1,   A1) :- football_variable_names(A1, _, _, _, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(2,   A2) :- football_variable_names(_, A2, _, _, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(3,   A3) :- football_variable_names(_, _, A3, _, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(4,   A4) :- football_variable_names(_, _, _, A4, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(5,   A5) :- football_variable_names(_, _, _, _, A5, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(6,   A6) :- football_variable_names(_, _, _, _, _, A6, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(7,   A7) :- football_variable_names(_, _, _, _, _, _, A7, _, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(8,   A8) :- football_variable_names(_, _, _, _, _, _, _, A8, _,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(9,   A9) :- football_variable_names(_, _, _, _, _, _, _, _, A9,  _, _, _, _, _, _, _, _, _, _, _, _).
get_key(10, A10) :- football_variable_names(_, _, _, _, _, _, _, _, _, A10, _, _, _, _, _, _, _, _, _, _, _).
get_key(11, A11) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, A11, _, _, _, _, _, _, _, _, _, _).
get_key(12, A12) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, A12, _, _, _, _, _, _, _, _, _).
get_key(13, A13) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, A13, _, _, _, _, _, _, _, _).
get_key(14, A14) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, A14, _, _, _, _, _, _, _).
get_key(15, A15) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, _, A15, _, _, _, _, _, _).
get_key(16, A16) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A16, _, _, _, _, _).
get_key(17, A17) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A17, _, _, _, _).
get_key(18, A18) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A18, _, _, _).
get_key(19, A19) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A19, _, _).
get_key(20, A20) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A20, _).
get_key(21, A21) :- football_variable_names(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A21).
