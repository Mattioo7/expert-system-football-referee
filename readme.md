# Obsługa "Pomocny Inteligentny Likwidator Kontrowersji Arbitrów (PILKA)"
Polecnie uruchamia interfejs użytkownika dla systemu ekspertowego PILKA.
```
swipl -s user_interface.pl -g main
```

Pojawią się pytania, na które należy odpowiedzieć, aby uzyskać odpowiedź na pytanie postawione w systemie ekspertowym PILKA.


# Interfejs eksperta
```
swipl -s expert.pl -g main
```

Pojawiają się opcje do wyboru pozwalająca modyfikować bazę wiedzy systemu ekspertowego PILKA.

0. Pokaz wszystkie decyzje
1. Pokaz wszystkie zasady
2. Pokaz warunki zasady
3. Dodaj nowa zasade
4. Usun zasade
5. Edytuj warunki zasady
6. Dodaj nowa decyzje
7. Zapisz zmiany
8. Zakoncz

Możliwe jest modyfikowanie decyzji systemu, zbioru zasad oraz warunków zasad. Zmiany można zapisać w bazie wiedzy utrwalając zmiany.

# Dynamika systemu
Program działa zadając dynamicznie pytania w zależności od poprzednich odpowiedzi. Niektóre pytania mogą być pomijane, jeśli nie mają wpływu na decyzję systemu. Przykładowo, podczas faulu nie ma znaczenia czy piłka jest poza linią boiska, więc pytanie o to zostanie pominięte.

# Inteligentne pomijanie pytań
System jest w stanie pomijać pytania, które nigdy nie mają wpływu na decyzję systemu. Przykładowo, podczas rozważania przewinienia przy rozmowie dwóch graczy ma sens, żeby określic kim oni są i umieścić takie dane w bazie danych. Jednakże, okazuje się, że nie są to informacje wymagane do uzyskania decyzji systemu, więc wystarczy zapytać tylko o jednego z graczy, reszta informacji zostanie wyciągnięta z innych pytań.

