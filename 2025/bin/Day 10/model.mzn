int: Counters;  % Rows
int: Buttons;   % Cols

set of int: ROWS = 1..Counters;
set of int: COLS = 1..Buttons;

array[ROWS, COLS] of int: A;
array[ROWS] of int: b;

array[COLS] of int: c = [ 1 | i in COLS ]; 

array[COLS] of var int: x; % Number of times a button is pressed
constraint forall(j in COLS) (
    x[j] >= 0
);

constraint forall(i in ROWS) (
    sum(j in COLS) (A[i, j] * x[j]) = b[i]
);

solve minimize sum(j in COLS) (c[j] * x[j]);

output [
    "x = ", show(x), "\n",
    "Objective Value = ", show(sum(j in COLS) (c[j] * x[j])), "\n"
];