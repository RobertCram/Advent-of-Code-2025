module Day02

# https://adventofcode.com/2025/day/02
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC
using Base.Iterators

struct IdRange 
    from
    to
end

IdRange(v::Vector) = IdRange(v[1], v[2])

function AOC.processinput(data)
    data = split(data, ',')
    parseboundary(string) = parse(Int, string)
    parserange(string) = IdRange(map(parseboundary, split(string, '-')))
    map(parserange, data)
end

function isinvalid1(id)
    strid = string(id)
    len = length(strid)
    if isodd(len) return false end
    strid[begin:len ÷ 2] == strid[len ÷ 2+1:end]
end

function isinvalid2(id)
    strid = string(id)
    len = length(strid)
    for i in 1:len ÷2
        if mod(len, i) == 0
            seq = strid[begin:i]
            if repeat(seq, len ÷ i) == strid return true end
        end
    end
    false
end

function invalidids(range, invalidator)
    r = range.from:range.to
    filter(invalidator, r)
end

function solve(input, invalidator)
    sum(flatten(map(invalidator, input)))
end

function setinvalidator(v)
    invalidator(range) = invalidids(range, v)
end

function solvepart1(input)
    solve(input, setinvalidator(isinvalid1))
end

function solvepart2(input)
    solve(input, setinvalidator(isinvalid2))
end

puzzles = [
    Puzzle(02, "test 1", "test.txt", solvepart1, 1227775554),
    Puzzle(02, "deel 1", solvepart1, 28844599675),
    Puzzle(02, "test 2", "test.txt", solvepart2, 4174379265),
    Puzzle(02, "deel 2", solvepart2, 48778605167)
]

printresults(puzzles)

end