% starting with the default predicates to handle the undefined cases
workstation_idle(_,_) :- fail.
avoid_workstation(_,_) :- fail.
avoid_shift(_,_) :- fail.
% so these above statements will be false if they dont exist instead of crashing

% main plan predicate
plan() :-
%
% define me :(
% assign employees to shifts
% build schedule moring
% build scheudle evening
% build schedule night
% validate all three schedules then its good

% base case for the recursive rule below
assign_all_employees([], []).

% assigning employees to shifts, recursive rule
assign_all_employees([E | Rest], [assigned(E, Shift, Workstation) | Assignments]) :- 
    shift(Shift),
    workstation(Workstation, _, _),
    can_work(E, Shift, Workstation),
    assign_all_employees(Rest, Assignments).

% defining shifts
shift(morning).
shift(evening).
shift(night).

% given constraints with file to determine if the employee can work, using negation-as-failure
can_work(Employee, Shift, Workstation) :-
    \+ avoid_shift(Employee, Shift),
    \+ avoid_workstation(Employee, Workstation),
    \+ workstation_idle(Workstation, Shift).

% ex: build_shift_schedule(morning, Assignments, Morning)
build_shift_schedule(Shift, Assignments, Schedule) :-
    findall(
        workstation(W, Employees),
        employees_at_workstation(Shift, W, Assignments, Employees),
        PreSchedule
    ),
    remove_empty_workstations(PreSchedule, Schedule).

%finds all employees assigned to workstation W during shift Shift
employees_at_workstation(Shift, W, Assignments, Employees) :-
    workstation(W, _, _),
    \+ workstation_idle(W, Shift),
    findall(
        E,
        member(assigned(E, Shift, W), Assignments),
        Employees
    ).


% recursively removing empty workstations from the schedule
% base case
remove_empty_workstations([], []).

% case for workstation with no employees
remove_empty_workstations([workstation(_, []) | Rest], Cleaned) :-
    remove_empty_workstations(Rest, Cleaned).

% regular case for a workstation that may have employees
remove_empty_workstations([workstation(W, Employees) | Rest], [workstation(W, Employees) | Cleaned]) :-
    Employees \= [],
    remove_empty_workstations(Rest, Cleaned).

