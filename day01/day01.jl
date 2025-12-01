module Day01

# https://adventofcode.com/2025/day/01
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC

const DIAL_SIZE = 100
const STARTPOSITION = 50
const CLOCKWISE = 'R'

struct Instruction
    direction
    distance
end

struct DialState
    position
    zeros
end

function AOC.processinput(data)
    data = split(data, '\n')
    map(line -> Instruction(line[1], parse(Int, line[2:end])), data)
end

function getdialposition(position, instruction)
    mod(position + ((instruction.direction == CLOCKWISE) ? instruction.distance : - instruction.distance), DIAL_SIZE)
end

function count_endpoints(dialstate, instruction)
    getdialposition(dialstate.position, instruction) == 0 ? 1 : 0
end

function count_allpasses(dialstate, instruction)
    position = instruction.direction == CLOCKWISE ? dialstate.position : mod(100 - dialstate.position, 100)
    (instruction.distance ÷ 100) + (position + mod(instruction.distance, 100) >= 100 ? 1 : 0)
end

function movedial(dialstate, instruction, countmethod)
    position = getdialposition(dialstate.position, instruction)
    DialState(position, dialstate.zeros + countmethod(dialstate, instruction))
end

function solve(instructions, countmethod)
    executeinstruction = (dialstate, instruction) -> movedial(dialstate, instruction, countmethod)
    reduce(executeinstruction, instructions, init = DialState(STARTPOSITION, 0))
end

function solvepart1(instructions)
    solve(instructions, count_endpoints)
end

function solvepart2(instructions)
    solve(instructions, count_allpasses)
end

puzzles = [
    Puzzle(01, "test 1", "test.txt", solvepart1, DialState(32, 3)),
    Puzzle(01, "deel 1", solvepart1, DialState(89, 982)),
    Puzzle(01, "test 2", "test.txt", solvepart2, DialState(32, 6)),
    Puzzle(01, "deel 2", solvepart2, DialState(89, 6106))
]

printresults(puzzles)

end