include("aoc.jl")
using .AOC

clearterminal()
println()
println(bold("Advent of Code 2025"))

if length(ARGS) == 0 || ((day = tryparse(Int, ARGS[1])) === nothing)
    for i in 1:12
        showdaytimed(i) || break
    end
else
    showdaytimed(day)
end

println()

