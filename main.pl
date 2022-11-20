% This is very slow. My a* algorithm checks stupid paths and can overlap very easily.
% However i cant be bothered to fix it so i wont.



% Taken and modified from https://gist.github.com/MuffinTheMan/7806903
% Get an element from a 2-dimensional list at (Row,Column)
% using 1-based indexing.
nth1_2d(Row, Column, List, Element) :-
    nth1(Row, List, SubList),
    nth1(Column, SubList, Element).

% Reads a file and retrieves the Board from it.
load_board(BoardFileName, Board):-
    see(BoardFileName),     % Loads the input-file
    read(Board),            % Reads the first Prolog-term from the file
    seen.                   % Closes the io-stream

run_pr(Row,Column, FileName):- % with fle name
load_board(FileName, Board),
check_alive(Row, Column, Board).

% Checks whether the group of stones connected to
% the stone located at (Row, Column) is alive or dead.
check_alive(Row, Column, Board):-
    nth1_2d(Row, Column, Board, Stone),
    (Stone = w), % input validition i guess
    exit_exists(Row, Column, Board).

exit_exists(Row, Column, Board):-
    Row > 0,
    Column > 0,
    len_of_list(Board, MaxRow),
    MaxRow1 is MaxRow + 1,
    Row < MaxRow1,
    len_of_column_helper(Board, FirstRow),
    len_of_list(FirstRow, MaxColumn),
    MaxColumn1 is MaxColumn + 1,
    Column < MaxColumn1,
    nth1_2d(Row,Column, Board, Stone), % Thanks to this thread i know how to branch https://stackoverflow.com/questions/1775651/whats-the-operator-in-prolog-and-how-can-i-use-it
    (
    Stone = w -> 
    set_element_to_b(Row, Column, Board, NewBoard),
    Row1 is Row + 1,
    Row2 is Row -1,
    Column1 is Column + 1,
    Column2 is Column - 1,
        (
        exit_exists(Row1, Column, NewBoard);
        exit_exists(Row2, Column, NewBoard);
        exit_exists(Row, Column1, NewBoard);
        exit_exists(Row, Column2, NewBoard)
        );
    Stone = e -> !
    ).

set_element_to_b(1, Column, [ToReplace|CurrentBoard], [SubBoard|CurrentBoard]):-
    set_element_in_list_to_b(Column, ToReplace, SubBoard).

set_element_to_b(Row, Column, [A|CurrentBoard], [A|NewBoard]):-
    Row1 is Row-1,
    set_element_to_b(Row1, Column, CurrentBoard, NewBoard).

set_element_in_list_to_b(1, [_|L], [b|L]).
set_element_in_list_to_b(IndexPos, [A|TheList], [A|NewList]):-
    IndexPos1 is IndexPos-1,
    set_element_in_list_to_b(IndexPos1, TheList, NewList).

len_of_column_helper([A|_], A).
len_of_list([],0). % "inspired by" https://www.geeksforgeeks.org/lists-in-prolog/#:~:text=Operations%20on%20Prolog%20Lists%3A%201%201.%20Find%20the,an%20element%20X%20from%20a%20list%20L%20
len_of_list([_|L], N):-
    len_of_list(L, N1),
    N is N1 + 1.
    



