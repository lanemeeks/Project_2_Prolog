% starting with the default predicates to handle the undefined cases
workstation_idle(_,_) :- fail.
avoid_workstation(_,_) :- fail.
avoid_shift(_,_) :- fail.
% so these above statements will be false if they don't exist instead of crashing

% main plan predicate
plan() :-
%
%define me :(
% assign employees to shifts
% build schedule moring
% build scheudle evening
% build schedule night
% validate all three schedules then its good

%base case for the recursive rule below
assign_all_employees([], []).

%assigning employees to shifts, recursive rule
assign_all_employees([E | Rest], [assigned(E, Shift, Workstation) | Assignments]) :- 
    shift(Shift),
    workstation(Workstation, _, _),
    can_work(E, Shift, Workstation),
    assign_all_employees(Rest, Assignments).

%defining shifts
shift(morning).
shift(evening).
shift(night).

% given constraints with file to determine if the employee can work, using negation-as-failure
can_work(Employee, Shift, Workstation) :-
    \+ avoid_shift(Employee, Shift),
    \+ avoid_workstation(Employee, Workstation),
    \+ workstation_idle(Workstation, Shift).

