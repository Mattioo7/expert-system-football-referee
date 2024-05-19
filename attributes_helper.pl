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



get_answer(ID, 1,   A1) :- football_situation(ID, A1, _, _, _, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 2,   A2) :- football_situation(ID, _, A2, _, _, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 3,   A3) :- football_situation(ID, _, _, A3, _, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 4,   A4) :- football_situation(ID, _, _, _, A4, _, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 5,   A5) :- football_situation(ID, _, _, _, _, A5, _, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 6,   A6) :- football_situation(ID, _, _, _, _, _, A6, _, _, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 7,   A7) :- football_situation(ID, _, _, _, _, _, _, A7, _, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 8,   A8) :- football_situation(ID, _, _, _, _, _, _, _, A8, _,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 9,   A9) :- football_situation(ID, _, _, _, _, _, _, _, _, A9,  _, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 10, A10) :- football_situation(ID, _, _, _, _, _, _, _, _, _, A10, _, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 11, A11) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, A11, _, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 12, A12) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, A12, _, _, _, _, _, _, _, _, _, _).
get_answer(ID, 13, A13) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, A13, _, _, _, _, _, _, _, _, _).
get_answer(ID, 14, A14) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, A14, _, _, _, _, _, _, _, _).
get_answer(ID, 15, A15) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A15, _, _, _, _, _, _, _).
get_answer(ID, 16, A16) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A16, _, _, _, _, _, _).
get_answer(ID, 17, A17) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A17, _, _, _, _, _).
get_answer(ID, 18, A18) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A18, _, _, _, _).
get_answer(ID, 19, A19) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A19, _, _, _).
get_answer(ID, 20, A20) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A20, _, _).
get_answer(ID, 21, A21) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A21, _).
