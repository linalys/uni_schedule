% Paschalina Lissoudi, 3116
% Anestis Christidis, 3066

% This function returns all the permutations of a given list.
permute([], []).
permute( [H1|T1], L2):-
    permute(T1, T2),
    insert(H1, T2, L2).
% This function inserts an element to a list.
insert(X, L, [X | L]).
insert(X, [H1|T1], [H1|T2]):-
    insert(X, T1, T2).

% This function is the one required for question 1.
schedule(A, B, C):-
    findall(X, attends(_, X), L), % Create a list L with all lesson entries.
    sort(L, X), % Sort and remove duplicates.
    permute(X, Y), % Get the permutations of that list.
    [X1, X2, X3, X4, X5, X6, X7, X8] = Y, % Assign each lesson to one variable.
    % Organise the lessons into weeks.
    A = [X1, X2, X3],
    B = [X4, X5, X6],
    C = [X7, X8].

% The function is the one required for question 2.
% In order to work properly, it requires parameters A, B and C as lists, filled with a schedule.
% It can work with the order: ?- schedule(A, B, C), schedule_errors(A, B, C, E).
% Arternatively, remove the (%) symbol before the first line of the function's code.
schedule_errors(A, B, C, E):-
    %schedule(A, B, C), 
    findall(X, attends(X,_), F), % Create a list F with all student entries.
    sort(F, Stud), % Sort and remove duplicates.
    se(Stud, A, B, E). % First auxiliary function

% This function increments the error counter recursively for every student.
% First parameter, the list, stores a list of all students.
% Parameters A, B store the schedule for first and second week.
% Parameter E returns the week's error.
se([],_A, _B, 0).  % The 0 initializes the Errors for all students.
se([H | T], A, B, E):-
    se(T, A, B, Temp), % Recursion is used first, to initialize the score.
    findall(X, attends(H, X),Sub), % Create a list F with all student entries.
    w_e(A, Sub, K), % Find errors for first week.
    w_e(B, Sub, L), % Find errors for second week.
    E is (Temp + K + L). % Set total number of errors.

% This function finds the number of errors for every student on one week.
% Parameter A stores the program of first or second week, the weeks that can create error.
% Parameter Sub is a list of lessons for a specific student.
% Parameter E returns the week's error.
%Case1: Student has all three subjects, so there is an error.
w_e(A, Sub, E):-
    [X1, X2, X3] = A,
     member(X1, Sub),
     member(X2, Sub),
     member(X3, Sub),
     E is 1.
% Cases 2, 3, 4: One of three lessons for the week is not one that the student has, so there is no error.
w_e(A, Sub, E):-
    [X1, _X2, _X3] = A,
    not(member(X1, Sub)),
    E is 0,!.
w_e(A, Sub, E):-
    [_X1, X2, _X3] = A,
    not(member(X2, Sub)),
    E is 0,!.
w_e(A, Sub, E):-
    [_X1, _X2, X3] = A,
    not(member(X3, Sub)),
    E is 0.

% This function is the one required for question 3.
minimal_schedule_errors(A, B, C, E):-
    findall(X, schedule_errors(_A, _B, _C, X), F), % Create a list F with all existing error numbers in all possible schedules.
    sort(F, Errors), % Sort and remove duplicates.
    min_list(Errors, E), % Get the minimum error number.
    schedule_errors(A, B, C, E). % Find the schedules that have the number of errors stated in the previous line.

% % This function returns the elements with the minimum value.
% list_min([X],X).
% list_min([H|T],H):-
% 	list_min(T,MT),
% 	H =< MT.					
% list_mim([H|T],MT):-
% 	list_min(T,MT),
% 	H > MT.


% This function is the one required for question 4.
score_schedule(A,B,C,S):-
    findall(X, attends(X,_), F), % Create a list F with all student entries.
    sort(F, Stud), % Sort the entries and remove duplicates
    s_s(Stud, A, B, C, S). % Find score for all students.


% This recursive function creates and returns the total score of the program for a given list of students.
% First parameter, list, is a list of all students.
% Parameters A, B, C store the specific schedule.
% Parameter S returns the total score.
s_s([],_A, _B, _C, 0). % Initialize with 0 the final score.
s_s([H | T], A, B, C, S):-
    s_s(T, A, B, C, Temp), % Recursion is used first, to initialize the score.
    findall(X, attends(H, X),Sub), % Create a list Sub with all lesson entries
    % Calulate score for each week.
    w_s(A, Sub, K),
    w_s(B, Sub, L),
    w_s(C, Sub, M),
    S is (Temp +K +L +M). % Add up each week's score to the total score.

% These functions calculate the score for each week.
% Many versions of it exist to handle the different lesson configurations.
% Parameter A is a list of lessons for the week, if it has three elements, it is used for first and second week, if it has only two elements, is is used for third week.
% Parameter Sub is a list of lessons a specific student has.
% Parameter S returns the score for the week.
% Case1: Three subjects, student has none of them, score is 0.
w_s(A, Sub, S):-
    [X1, X2, X3] = A,
    not(member(X1, Sub)),
    not(member(X2, Sub)),
    not(member(X3, Sub)),
    S is 0,!.
% Case2: Three subjects, student has all of them, score is -7.
w_s(A, Sub, S):-
    [X1, X2, X3] = A,
     member(X1, Sub),
     member(X2, Sub),
     member(X3, Sub),
     S is -7,!.
% Cases 3 and 4: Three subjects, student has two of them directly one after the other, score is 1.
w_s(A, Sub, S):-
    [X1, X2, _X3] = A,
     member(X1, Sub),
     member(X2, Sub),
     S is 1,!.
w_s(A, Sub, S):-
    [_X1, X2, X3] = A,
     member(X3, Sub),
     member(X2, Sub),
     S is 1,!.
% Case5: Three subjects, student has two of them on Monday and Friday, score is 3.
w_s(A, Sub, S):-
    [X1, _X2, X3] = A,
     member(X1, Sub),
     member(X3, Sub),
     S is 3,!.
% Cases 6, 7, 8: Three subjects, student has one of them, score is 7.
w_s(A, Sub, S):-
    [X1, _X2, _X3] = A,
     member(X1, Sub),
     S is 7.
w_s(A, Sub, S):-
    [_X1, X2, _X3] = A,
     member(X2, Sub),
     S is 7.
w_s(A, Sub, S):-
    [_X1, _X2, X3] = A,
     member(X3, Sub),
     S is 7.
% Case9: Two subjects, student has none of them, score is 0.
w_s(A, Sub, S):-
    [X1, X2] = A,
    not(member(X1, Sub)),
    not(member(X2, Sub)),
    S is 0,!.
% Case10: Two subjects, student has both of them on Monday and Wednsday, score is 1.
w_s(A, Sub, S):-
    [X1, X2] = A,
     member(X1, Sub),
     member(X2, Sub),
     S is 1,!.
% Cases 11 and 12: Two subjects, student has one of them, score is 7.
w_s(A, Sub, S):-
    [X1, _X2] = A,
     member(X1, Sub),
     S is 7,!.
w_s(A, Sub, S):-
    [_X1, X2] = A,
     member(X2, Sub),
     S is 7,!.


%This function is the one required for question 5.
maximum_score_schedule(A, B, C, E, S):-
    findall(X, schedule_errors(_A, _B, _C, X), F), % Create a list F with all errors for all possible schedules.
    sort(F, Errors), % Sort and remove duplicates.
    min_list(Errors, E), % Get the minimum error.
    schedule_errors(A, B, C, E), % Find the schedules that have the number of errors stated in the previous line.
    findall(Y, score_schedule(A, B, C, Y), G), % Create a list G with all scores for all possible schedules.
    sort(G, Scores), % Sort and remove duplicates.
    max_list(Scores, S), % Get the maximum score.
    score_schedule(A, B, C, S). % Find the schedules that have the score stated in the previous line, with minimal error.
