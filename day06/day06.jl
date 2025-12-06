module Day06

# https://adventofcode.com/2025/day/06
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC

function AOC.processinput(data)
    data = split(data, '\n')
    data[1:end-1], data[end]
end

function getcolumn(col, numbers)
    map(r -> r[col], numbers)
end

function problempositions(operations)
    append!(findall(!isspace, operations), length(operations) + 2)
end

function getproblemnumbers1(problemid, numbers, positions)
    first, last = positions[problemid], positions[problemid+1] - 2
    parse.(Int, map(r -> r[first:last], numbers))
end

function getproblemnumbers2(problemid, numbers, positions)
    first, last = positions[problemid], positions[problemid+1] - 2
    parse.(Int, map(i -> reduce((s, c) -> s * c[i], numbers, init=""), first:last))
end

function calculate(problemid, getnumbers, operations)
    operator = split(operations)[problemid] == "+" ? (+) : (*)
    reduce(operator, getnumbers(problemid))
end

function solve(numbers, operations, getproblemnumbers)
    positions = problempositions(operations)
    getnumbers(problemid) = getproblemnumbers(problemid, numbers, positions)
    sum(map(i -> calculate(i, getnumbers, operations), 1:length(split(operations))))
end

function solvepart1((numbers, operations))
    solve(numbers, operations, getproblemnumbers1)
end

function solvepart2((numbers, operations))
    solve(numbers, operations, getproblemnumbers2)
end

puzzles = [
    Puzzle(06, "test 1", "test.txt", solvepart1, 4277556),
    Puzzle(06, "deel 1", solvepart1, 4648618073226),
    Puzzle(06, "test 2", "test.txt", solvepart2, 3263827),
    Puzzle(06, "deel 2", solvepart2, 7329921182115)
]

printresults(puzzles)

end