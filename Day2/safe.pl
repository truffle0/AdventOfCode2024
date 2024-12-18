#!/bin/env swipl

:- [utils].

data_from_file(File, Data) :-
    open(File, read, Stream),
    get_lines(Stream, Lines),
    close(Stream),
    maplist([X, Y]>>(
        split_string(X, " ", "", Terms),
        maplist([A, B] >> number_string(B, A), Terms, Y)
    ), Lines, Data).

% safe(+Row)
% defines what it means for a row to be safe
safe([H|T]) :-
    % all values in the list must have diff of 1, 2 or 3.
    foldl([X,Y,X]>>(
        diff(X, Y, Z),
        between(Z, 1, 3)
    ), T, H, _),
    % list must be strictly increasing or decreasing
    (decreasing([H|T]) ; increasing([H|T])).

% nearly_safe(+Row)
% whether a row can be considered safe after removing a single value
nearly_safe(Row) :-
    findall(P, nth0(_, Row, _, P), Perms),
    any(safe, Perms).

% string_flatten(+ListStr, -Str)
% turns of list of strings into a continous string
% (better than a thousand lines of append)
string_flatten([], "").
string_flatten([H|T], X) :-
    string(H),
    string_flatten(T, Rest),
    string_concat(H, Rest, X).

% writes a part number and a result
report(Part, Output) :-
    number_string(Part, S1),
    number_string(Output, S2),
    string_flatten(["Part ", S1, ": ", S2, "\n"], Out),
    write(Out).


main(Argv) :-
    % read input
    nth0(0, Argv, File),
    data_from_file(File, Data),
    
    % part 1
    count(safe, Data, Sol1),
    report(1, Sol1),

    % part 2
    count(nearly_safe, Data, Sol2),
    report(2, Sol2).

:- initialization (main() ; write("No input!\n")), halt.