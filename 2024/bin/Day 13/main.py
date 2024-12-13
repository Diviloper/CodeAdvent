from pathlib import Path
import re
import os
from ortools.linear_solver import pywraplp


class Position:
    @classmethod
    def from_coords(cls, x, y):
        return cls(x, y)

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __repr__(self):
        return f"Position(x={self.x}, y={self.y})"


class Machine:
    def __init__(self, a, b, prize):
        self.a = a
        self.b = b
        self.prize = prize

    def __str__(self):
        return f"A: {self.a}, B: {self.b}, Prize: {self.prize}"


def parse_machine(source):
    reg = re.compile(r".* X[+=](\d+), Y[+=](\d+)")

    matches = [reg.match(line) for line in source.split("\n")]

    positions = [
        Position.from_coords(int(match.group(1)), int(match.group(2)))
        for match in matches
        if match
    ]

    if len(positions) != 3:
        raise ValueError("Expected exactly 3 positions in the source input")

    a, b, prize = positions
    return Machine(a, b, prize)


def main():
    input_file = Path("./input.txt")
    input_data = input_file.read_text().strip()
    machines = [parse_machine(block) for block in input_data.split("\n\n")]

    first = sum(solveMachine(m) for m in machines)
    print(first)


def solveMachine(machine: Machine) -> int:
     # Create the mip solver with the CP-SAT backend.
    solver = pywraplp.Solver.CreateSolver("SCIP")
    if not solver:
        return

    infinity = solver.infinity()
    # x and y are integer non-negative variables.
    aP = solver.IntVar(0, infinity, "aP")
    bP = solver.IntVar(0, infinity, "bP")

    solver.Add(aP*machine.a.x + bP*machine.b.x == machine.prize.x + 10000000000000)
    solver.Add(aP*machine.a.y + bP*machine.b.y == machine.prize.y + 10000000000000)

    solver.Maximize(3*aP + bP)

    status = solver.Solve()

    if status == pywraplp.Solver.OPTIMAL:
        return int(solver.Objective().Value())
    else:
        print("The problem does not have an optimal solution.")
        return 0



if __name__ == "__main__":
    main()
