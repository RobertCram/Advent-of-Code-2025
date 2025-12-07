module Day07

# https://adventofcode.com/2025/day/07
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC
using DataStructures

function AOC.processinput(data)
    data = split(data, '\n')
    findall.('^', data[2:end]), findall('S', data[1])[1]
end

struct State
    beams
    splits
end

function splitbeams(state, splitters)
    splits = state.splits
    b = DefaultDict(0)
    for (beam, count) in state.beams
        if beam in splitters
            b[beam-1] += count
            b[beam+1] += count
            splits += 1
        else
            b[beam] += count
        end
    end
    State(b, splits)
end

function solve(splitters, beam)
    reduce((acc, r) -> splitbeams(acc, r), splitters, init = State(Dict(beam => 1), 0))
end

function solvepart1((splitters, beam))
    solve(splitters, beam).splits    
end

function solvepart2((splitters, beam))
    sum(values(solve(splitters, beam).beams))
end

puzzles = [
    Puzzle(07, "test 1", "test.txt", solvepart1, 21),
    Puzzle(07, "deel 1", solvepart1, 1560),
    Puzzle(07, "test 2", "test.txt", solvepart2, 40),
    Puzzle(07, "deel 2", solvepart2, 25592971184998)
]

printresults(puzzles)

end