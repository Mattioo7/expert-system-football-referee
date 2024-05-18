football_situation(1,'Nic','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','Brak_reakcji').
football_situation(2,'Rozmowa','A','_','_','_','_','_','_','_','_','_','_','_','_','_','_','Sedzia','Sedzia','_','_','_','Brak_reakcji').
football_situation(3,'Rozmowa','B','_','_','_','_','_','_','_','_','_','_','_','_','_','_','Sedzia','Gospodarz','Tak','_','Tak','Brak_reakcji').

% Rule to get the attribute value by index.
get_attr_value(ID, 1, A1) :- football_situation(ID, A1, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 2, A2) :- football_situation(ID, _, A2, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 3, A3) :- football_situation(ID, _, _, A3, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 4, A4) :- football_situation(ID, _, _, _, A4, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 5, A5) :- football_situation(ID, _, _, _, _, A5, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 6, A6) :- football_situation(ID, _, _, _, _, _, A6, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 7, A7) :- football_situation(ID, _, _, _, _, _, _, A7, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 8, A8) :- football_situation(ID, _, _, _, _, _, _, _, A8, _, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 9, A9) :- football_situation(ID, _, _, _, _, _, _, _, _, A9, _, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 10, A10) :- football_situation(ID, _, _, _, _, _, _, _, _, _, A10, _, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 11, A11) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, A11, _, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 12, A12) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, A12, _, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 13, A13) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, A13, _, _, _, _, _, _, _, _, _).
get_attr_value(ID, 14, A14) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, A14, _, _, _, _, _, _, _, _).
get_attr_value(ID, 15, A15) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A15, _, _, _, _, _, _, _).
get_attr_value(ID, 16, A16) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A16, _, _, _, _, _, _).
get_attr_value(ID, 17, A17) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A17, _, _, _, _, _).
get_attr_value(ID, 18, A18) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A18, _, _, _, _).
get_attr_value(ID, 19, A19) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A19, _, _, _).
get_attr_value(ID, 20, A20) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A20, _, _).
get_attr_value(ID, 21, A21) :- football_situation(ID, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, A21, _).


% Rule to get the attribute name based on index
attribute_name(1, 'Co sie stalo?').
attribute_name(2, 'Za jaka linie wypadla pilka?').
attribute_name(3, 'Linia koncowa na połowie ktorej druzyny?').
attribute_name(4, 'Zawodnik, której drużyny dotknął ostatni?').
attribute_name(5, 'Czy podanie za linią obrony?').
attribute_name(6, 'Adresat podania jest dalej od bramki przeciwnika niż obrońcy drużyny przeciwnej?').
attribute_name(7, 'Która dużyna wykonała podanie?').
attribute_name(8, 'Czy kontakt graczy zgodny z przepisami?').
attribute_name(9, 'Dynamika faulu?').
attribute_name(10, 'Gdzie został gracz dotknięty?').
attribute_name(11, 'Gdzie nastąpił (faul/zajście) ?').
attribute_name(12, 'Kto przekroczył przepisy?').
attribute_name(13, 'W czyjej bramce?').
attribute_name(14, 'Gdzie (dotknięto ręką)?').
attribute_name(15, 'Kto doknął (ręką)?').
attribute_name(16, 'Czy powstrzymał akcję (przez rękę)?').
attribute_name(17, 'Kto jest osobą 1 (w rozmowie)?').
attribute_name(18, 'Kto jest osobą 2 (w rozmowie)?').
attribute_name(19, 'Czy obelgi?').
attribute_name(20, 'Kto obraził jako pierwszy?').
attribute_name(21, 'Czy ma już żółtą kartkę?').


% Initial attributes
attributes([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21]).
%attributes([1, 2]).
