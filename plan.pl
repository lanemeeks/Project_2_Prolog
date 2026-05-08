
% starting with the default predicates to handle the undefined cases, comment out if used in input
workstation_idle(_,_) :- fail.
avoid_workstation(_,_) :- fail.
avoid_shift(_,_) :- fail.
% so these above statements will be false if they dont exist instead of crashing

% main plan predicate
plan(plan(Morning, Evening, Night)) :-
    findall(E, employee(E), Employees),
    assign_all_employees(Employees, Assignments),
    build_shift_schedule(morning, Assignments, Morning),
    valid_schedule(Morning),
    build_shift_schedule(evening, Assignments, Evening),
    valid_schedule(Evening),
    build_shift_schedule(night, Assignments, Night),
    valid_schedule(Night).

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

% recursively validating the schedule built already
valid_schedule([]).

valid_schedule([workstation(W, Employees) | Rest]) :-
    length(Employees, Count),
    workstation(W, Min, Max),
    Count >= Min,
    Count =< Max,
    valid_schedule(Rest).