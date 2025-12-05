module Day04

# https://adventofcode.com/2025/day/04
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC

directions = [
    [0,1],
    [0,-1],
    [1,1],
    [1, -1],
    [-1, 1],
    [-1, -1],
    [1, 0],
    [-1, 0]
]

global dimensions

function AOC.processinput(data)
    floorplan = map(line -> split(line, ""), split(data, '\n'))
    global dimensions = (length(floorplan[1]), length(floorplan))
    floorplan
end

function isvalidindex(row, col)
    row >= 1 && col >= 1 && row <= dimensions[1] && col <= dimensions[2]
end

function count_rolls(floorplan, row, col)
    adjacents = map(d -> [row, col] + d, directions)
    sum(map(a -> (isvalidindex(a[1], a[2]) && floorplan[a[1]][a[2]] == "@" ? 1 : 0), adjacents))
end

function getaccessibles(floorplan)
    accessibles = []
    for row in 1:dimensions[1]
        for col in 1:dimensions[2]            
            if floorplan[row][col] == "@" && count_rolls(floorplan, row, col) < 4
                push!(accessibles, [row, col])
            end
        end
    end
    accessibles
end

function solvepart1(floorplan)
    length(getaccessibles(floorplan))
end

function solvepart2!(floorplan)
    removed = 0
    while true
        accessibles = getaccessibles(floorplan)
        length(accessibles) !== 0 || break

        foreach(((r, c),) -> floorplan[r][c] = ".", accessibles)
        removed += length(accessibles)
    end
    removed
end

puzzles = [
    Puzzle(04, "test 1", "test.txt", solvepart1, 13),
    Puzzle(04, "deel 1", solvepart1, 1478),
    Puzzle(04, "test 2", "test.txt", solvepart2!, 43),
    Puzzle(04, "deel 2", solvepart2!, 9120)
]

printresults(puzzles)

end