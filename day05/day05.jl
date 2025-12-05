module Day05

# https://adventofcode.com/2025/day/05
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC

function AOC.processinput(data)
    a, b = split(data, "\n\n")
    ranges = map(r -> [parse(Int, r[1]), parse(Int, r[2])],split.(split(a), "-"))
    ingredients = parse.(Int, split(b))
    ranges, ingredients
end

function isfresh(ingredient, ranges)
    reduce((result, range) -> result || ingredient >= range[1] && ingredient <= range[2], ranges, init = false)
end

function combineranges(r1, r2)
    # non overlapping ranges
    r1[2] < r2[1] && return [r1, r2]
    r1[1] > r2[2] && return [r1, r2]
    r2[2] < r1[1] && return [r1, r2]
    r2[1] > r1[2] && return [r1, r2]

    # one range contains another
    r1[1] <= r2[1] && r1[2] >= r2[2] && return [r1]
    r2[1] <= r1[1] && r2[2] >= r1[2] && return [r2]

    # overlapping ranges
    r1[1] < r2[1] && return [[r1[1], r2[2]]]
    r1[2] > r2[2] && return [[r2[1], r1[2]]]
    r2[1] < r1[1] && return [[r2[1], r1[2]]]
    r2[2] > r1[2] && return [[r1[1], r2[2]]]
end

function combine(ranges, r2)
    result = []
    for r1 in ranges
        append!(result, combineranges(r1, r2))
    end
    result
end

function solvepart1((ranges, ingredients))
    isfreshingredient(ingredient) = isfresh(ingredient, ranges)
    sum(isfreshingredient.(ingredients))
end

function solvepart2((ranges, _))
    while true
        oldranges = copy(ranges)
        for range in ranges
            setdiff!(ranges, [range])
            ranges = unique(combine(ranges, range))
        end
        Set(oldranges) != Set(ranges) || break
    end
    sum(map(r -> r[2]-r[1]+1,ranges))
end

puzzles = [
    Puzzle(05, "test 1", "test.txt", solvepart1, 3),
    Puzzle(05, "deel 1", solvepart1, 511),
    Puzzle(05, "test 2", "test.txt", solvepart2, 14),
    Puzzle(05, "deel 2", solvepart2, 350939902751909)
]

printresults(puzzles)

end