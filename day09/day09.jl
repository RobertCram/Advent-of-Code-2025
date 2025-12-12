module Day09

# https://adventofcode.com/2025/day/09
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC
using .Iterators
import Base.show

struct Point
    x
    y
end

function show(io::IO, p::Point)
    print(io, "P($(p.x),$(p.y))")
end

Point(a) = Point(a[1], a[2])

function AOC.processinput(data)
    data = Point.(map(p -> (parse.(Int, p)), split.(split(data, '\n'), ",")))
end

function area(p1, p2)
    (abs(p1.x - p2.x) + 1) * (abs(p1.y - p2.y) + 1)
end

function getareas(i, tiles)
    map(j -> (i, j, area(tiles[i], tiles[j])), i+1:length(tiles))
end

function getareas(tiles)
    collect(flatten(map(i -> getareas(i, tiles), 1:length(tiles))))
end

function getarealines(p1, p2)
    xmax = maximum([p1.x, p2.x])
    xmin = minimum([p1.x, p2.x])
    ymax = maximum([p1.y, p2.y])
    ymin = minimum([p1.y, p2.y])
    [(Point(xmin, ymin), Point(xmax, ymin)), (Point(xmin, ymax), Point(xmax, ymax)), (Point(xmin, ymin), Point(xmin, ymax)), (Point(xmax, ymin), Point(xmax, ymax))]
end

function shapelines(tiles)
    lines = collect(zip(tiles, push!(tiles[2:end], tiles[1])))
    horizontals = filter(line -> line[1].y == line[2].y , lines) 
    verticals = filter(line -> line[1].x == line[2].x , lines) 
    horizontals, verticals
end

function isintersecting(arealine, horizontals, verticals)    
    if arealine[1].x == arealine[2].x
        for horizontal in horizontals
            horizontal[1].y >= maximum([arealine[1].y, arealine[2].y]) && continue
            horizontal[1].y <= minimum([arealine[1].y, arealine[2].y]) && continue
            maximum([horizontal[1].x, horizontal[2].x]) < arealine[1].x && continue
            minimum([horizontal[1].x, horizontal[2].x]) > arealine[1].x && continue
            return true
        end
    else
        for vertical in verticals
            vertical[1].x >= maximum([arealine[1].x, arealine[2].x]) && continue
            vertical[1].x <= minimum([arealine[1].x, arealine[2].x]) && continue
            maximum([vertical[1].y, vertical[2].y]) < arealine[1].y && continue
            minimum([vertical[1].y, vertical[2].y]) > arealine[1].y && continue
            return true
        end
    end
    return false
end

function isvalidarea(p1, p2, horizontals, verticals)
    arealines = getarealines(p1, p2)
    
    intersecting = false
    for arealine in arealines
        intersecting = intersecting || isintersecting(arealine, horizontals, verticals)
        intersecting && break
    end

    !intersecting
end


function solvepart1(tiles)
    sort(getareas(tiles), by = a -> a[3], rev = true)[1][3]
end

function solvepart2(tiles)
    horizontals, verticals = shapelines(tiles)
    areas = filter(area -> isvalidarea(tiles[area[1]], tiles[area[2]], horizontals, verticals), getareas(tiles))
    sort(areas, by = a -> a[3], rev = true)[1][3]
end

puzzles = [
    Puzzle(09, "test 1", "test.txt", solvepart1, 50),
    Puzzle(09, "deel 1", solvepart1, 4741451444),
    Puzzle(09, "test 2", "test.txt", solvepart2, 24),
    Puzzle(09, "deel 2", solvepart2, 1562459680)
]

printresults(puzzles)

end