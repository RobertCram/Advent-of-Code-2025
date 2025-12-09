module Day08

# https://adventofcode.com/2025/day/08
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC
using .Iterators

struct Box 
    x
    y
    z
end

function AOC.processinput(data)
    data = map(c -> Box(parse.(Int, c)...), split.(split(data, '\n'), ","))
end

function distance(b1::Box, b2::Box)
    sqrt((b1.x - b2.x)^2 + (b1.y - b2.y)^2 + (b1.z - b2.z )^2)
end

function distances(i, boxes)
    distances = map(j -> (i, j, distance(boxes[i], boxes[j])), i+1:length(boxes))
end

function distances(boxes)
    sort(collect(flatten(map(i -> distances(i, boxes), 1:length(boxes)))), by  = d -> d[3])
end

function getcircuits(connections, boxes)
    count = 0
    circuits = [] 
    for pair in distances(boxes)
        found1 = findfirst(circuit -> (pair[1] in circuit), circuits)
        found2 = findfirst(circuit -> (pair[2] in circuit), circuits)
        if (found1 === nothing) && (found2 === nothing)
            push!(circuits, Set([pair[1], pair[2]]))
        elseif found1 !== nothing && found2 === nothing
            push!(circuits[found1], pair[2])
        elseif found2 !== nothing && found1 === nothing
            push!(circuits[found2], pair[1])
        else
            if found1 !== found2
                union!(circuits[found1], circuits[found2])
                deleteat!(circuits, found2)
            end
        end
        count += 1
        length(circuits[1]) == length(boxes) && return circuits, pair
        connections > 0 && count == connections && return circuits, pair
    end
end

function solve1(connections, boxes)
    a = sort(unique(length.(getcircuits(connections, boxes)[1])), order = Base.Order.Reverse)
    a[1] * a[2] * a[3]
end

function solve2(boxes)
    i1, i2, _ = getcircuits(0, boxes)[2]
    boxes[i1].x * boxes[i2].x
end

function solvetest1(boxes)
    solve1(10, boxes)
end

function solvepart1(boxes)
    solve1(1000, boxes)
end

function solvepart2(boxes)
    solve2(boxes)
end

puzzles = [
    Puzzle(08, "test 1", "test.txt", solvetest1, 40),
    Puzzle(08, "deel 1", solvepart1, 57970),
    Puzzle(08, "test 2", "test.txt", solvepart2, 25272),
    Puzzle(08, "deel 2", solvepart2, 8520040659)
]

printresults(puzzles)

end