% Form of board, x for full, o for vacant spaces.  Starting is
% [ [o], [x, x], [x, x, x], [x, x, x, x] ]

% Legal moves along a line.
linemove([x, x, o | T], [o, o, x | T]).
linemove([o, x, x | T], [x, o, o | T]).
linemove([H|T1], [H|T2]) :- linemove(T1,T2).

% Rotate the board
rotate([ [A], [B, C], [D, E, F], [G, H, I, J], [K, L, M, N, O]],
        [ [K], [L, G], [M, H, D], [N, I, E, B], [O, J, F, C, A]]).

% A move on a single line.
horizontalmove([A|T],[B|T]) :- linemove(A,B).
horizontalmove([H|T1],[H|T2]) :- horizontalmove(T1,T2).

% Perform one correct move into an empty hole.
jmove(B,A) :- horizontalmove(B,A).
jmove(B,A) :- rotate(B,BR), horizontalmove(BR,BRJ), rotate(A,BRJ).
jmove(B,A) :- rotate(BR,B), horizontalmove(BR,BRJ), rotate(BRJ,A).

% List of possible leagal board states
series(From, To, [From, To]) :- jmove(From, To).
series(From, To, [From, By | Rest])
        :- jmove(From, By), 
           series(By, To, [By | Rest]).

% Print a series of boards.  The board is printed over several lines
% allowing it to be more human readable
% The write_ln predicate is a built-in which always
% succeeds (is always satisfied), but prints as a side-effect.  Therefore
% print_series(Z) will succeed with any list, and the members of the list
% will be printed, one per line, as a side-effect of that success.
print_series_r([]) :- 
    write_ln('*******************************************************').
print_series_r([X|Y]) :- write_ln(X), print_series_r(Y).
print_series(Z) :- 
    write_ln('\n*******************************************************'),
    print_series_r(Z).

% A solution.
solution(L) :- series([[o], [x, x], [x, x, x], [x, x, x, x], [x, x, x, x, x]],
                   [[x], [o, o], [o, o, o], [o, o, o, o], [o, o, o, o, o]], L).

% Find and print out a solution.  
solve :- solution(X), print_series(X).

% Find all of the solutions.
solveall :- solve, fail.

% Step through all soulitions.
solvestep(Z) :- Z = next, solution(X), print_series(X).