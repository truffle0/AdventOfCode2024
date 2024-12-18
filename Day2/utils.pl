% pull all lines from a stream into a list
get_lines(Stream, Lines) :-
    read_line_to_string(Stream, Ln),
    Ln \== end_of_file -> (
        get_lines(Stream, T),
        Lines = [Ln|T]
    ) ; (
        Lines = []
    ).

% simple numeric predicates
diff(A, B, C) :-
    C is abs(A - B).

between(X, Min, Max) :-
    Min =< X,
    X =< Max.


% strictly increasing or decreasing lists
% increasing(+List)
increasing([]).
increasing([H|T]) :- foldl([X,Y,X]>>(X < Y), T, H, _).

% decreasing(+List)
decreasing([]).
decreasing([H|T]) :- foldl([X,Y,X]>>(X > Y), T, H, _).


% empty(List)
% predicate for an empty list
empty([]).

% count(+Goal, +List, -Num)
% similar to convlist or maplist, but just counts successes
count(_, [], 0) :- !.
count(Goal, [H|T], N) :-
    count(Goal, T, Rest),
    (call(Goal, H) -> ( 
        N is 1 + Rest
    ) ; (
        N is Rest
    )).

% all(+Goal, List)
% all elements satisfy the goal
all(_, []) :- !.
all(Goal, [H|T]) :-
    call(Goal, H),
    all(Goal, T).

% any(+Goal, List)
% any element satisfies the goal
any(Goal, [H|T]) :-
    call(Goal, H) -> ! ;
    any(Goal, T). 