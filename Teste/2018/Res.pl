%airport(Name, ICAO, Country)
airport('Aeroporto Francisco Sa Carneiro', 'LPPR', 'Portugal').
airport('Aeroporto Humberto Delgado', 'LPPT', 'Portugal').
airport('Aeropuerto Adolfo Suarez Madrid-Barajas', 'LEMD', 'Spain').
airport('Aeroport de Paris-Charles-de-Gaule Roissy Airport', 'LFPG', 'France').
airport('Aeroporto Internazionale di Roma-Fiumicino - Leonardo da Vinci', 'LIRF', 'Italy').

%company(ICAO, Name, Year, Contry)
company('TAP', 'TAP Air Portugal', 1945, 'Portugal').
company('RYR', 'Ryanair', 1984, 'Ireland').
company('AFR', 'Societe Air France', 1933, 'France').
company('BAW', 'British Airways', 1974, 'United Kingdom').

%flight(Designation, Origin, Destination, DepartureTime, Duration, Company)
flight('TP1923', 'LPPR', 'LPPT', 1115, 55, 'TAP').
flight('TP1968', 'LPPT', 'LPPR', 2235, 55, 'TAP').
flight('TP842', 'LPPT', 'LIRF', 1450, 195, 'TAP').
flight('TP843', 'LIRF', 'LPPT', 1935, 195, 'TAP').
flight('FR5483', 'LPPR', 'LEMD', 630, 105, 'RYR').
flight('FR5484', 'LEMD', 'LPPR', 1935, 105, 'RYR').
flight('AF1024', 'LFPG', 'LPPT', 940, 155, 'AFR').
flight('AF1025', 'LPPT', 'LFPG', 1310, 155, 'AFR').

short(Flight):-
    flight(Flight,_,_,_,H,_),H<90.

shorter(Flight1,Flight2,Flight1):-
    flight(Flight1,_,_,_,H1,_),
    flight(Flight2,_,_,_,H2,_),
    H1<H2.

shorter(Flight1,Flight2,Flight2):-
    flight(Flight1,_,_,_,H1,_),
    flight(Flight2,_,_,_,H2,_),
    H2<H1.

arrivalTime(Flight, ArrivalTime) :-
    flight(Flight, _, _, DepartureTime, Duration, _),
    timeToMinutes(DepartureTime, DepartureTimeMinutes),
    ArrivalTimeMinutes is DepartureTimeMinutes + Duration,
    minutesToTime(ArrivalTimeMinutes, ArrivalTime).

timeToMinutes(Time, Minutes) :-
    Hours is div(Time, 100),
    Min is mod(Time, 100),
    Minutes is Hours * 60 + Min.

minutesToTime(Minutes, Time) :-
    Hours is mod(div(Minutes, 60), 24),
    Min is mod(Minutes, 60),
    Time is Hours * 100 + Min.


operates(Company, Country) :-
    company(Company, _, _, _),
    flight(_, ICAO, _, _, _, Company),
    airport(_, ICAO, Country).

operates(Company, Country) :-
    company(Company, _, _, _),
    flight(_, _, ICAO, _, _, Company),
    airport(_, ICAO, Country).

countries(Company, ListOfCountries) :-
    countries(Company, [], ListOfCountries), !.

countries(Company, Acc, ListOfCountries) :-
    operates(Company, Country),
    \+member(Country, Acc),
    append(Acc, [Country], NewAcc),
    countries(Company, NewAcc, ListOfCountries).

countries(_, ListOfCountries, ListOfCountries).

pairableFlights:-
    flight(Flight1,_,D,_,_,_),
    flight(Flight2,D,_,H2,_,_),
    arrivalTime(Flight1,AT),
    timeToMinutes(AT,AM),
    timeToMinutes(H2,HM),
    Diff is HM-AM,
    Diff >=30,Diff=<90,
    write(D),write(' - '),write(Flight1),write(' \\ '),write(Flight2),nl,
    fail.

pairableFlights.

tripDays(Trip, Time, FlightTimes, Days) :-
    tripDays(Trip, Time, [], FlightTimes, 1, Days).

tripDays([_ | []], _, FlightTimes, FlightTimes, Days, Days).

tripDays([Country, Destination | Rest], Time, Acc, FlightTimes, DaysAcc, Days) :-
    flight(Flight, Origin, Destin, DepartureTime, _, _),
    airport(_, Origin, Country),
    airport(_, Destin, Destination),
    timeToMinutes(DepartureTime, DepartureMin),
    timeToMinutes(Time, TimeMin),
    (
        DepartureMin < TimeMin + 30,
        NewDaysAcc is DaysAcc + 1
        ;
        NewDaysAcc = DaysAcc
    ),
    arrivalTime(Flight, ArrivalTime),
    append(Acc, [DepartureTime], NewAcc),
    tripDays([Destination | Rest], ArrivalTime, NewAcc, FlightTimes, NewDaysAcc, Days).

:- use_module(library(lists)).

avgFlightLengthFromAirport(Airport,AvgLength):-
    findall(
        Dur,
        (
            (
                (flight(_, Airport, _, _, Dur, _));
                (flight(_, _, Airport, _, Dur, _))
            )
        ),
        Lengths),
    sumlist(Lengths, SumDur),
    length(Lengths, Div),
    AvgLength is SumDur/Div.

mostInternational(L):-
    setof(
        Count,
        (
            company(C,_,_,_),
            countries(C,CCountry),
            length(CCountry,Count)    
        ),
        Counts    
    ),
    reverse(Counts,[MaxCount|_]),
    findall(
        Company,
        (
            company(Company,_,_,_),
            countries(Company,Countries),
            length(Countries, MaxCount)    
        ),
        ListOfCompanies
    ),!.

make_pairs(L, P, [X-Y|Zs]) :-
    select(X, L, L2),
    select(Y, L2, L3),
    G =.. [P, X, Y], G,
    make_pairs(L3, P, Zs).

make_pairs([], _, []).

diff_max_2(X, Y) :- X < Y, X >= Y-2.