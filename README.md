How to run my code from terminal:

Open terminal and swipl. Within the input file note which predicates are used, ex: "avoid_shift" or "workstation_idle", then comment out the lines at the top of the plan.pl which define those predicates to avoid errors. Then consult plan.pl and consult tthe input file. Query plan(P), it will return a valid schedule or flase.

plan.pl
This file contains my main plan predicate that builds a work plan from the facts given. Should consult this file when querying about the work schedule.

devlog
Development history for this project and the plan.pl file.