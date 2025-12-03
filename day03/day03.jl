module Day03

# https://adventofcode.com/2025/day/03
# https://julialang.zulipchat.com/#narrow/channel/545151-advent-of-code-.282025.29/

include("./../aoc.jl")
using .AOC

function AOC.processinput(data)
    banks = split(data, '\n')
    parsebank(bank) = parse.(Int, split(bank, ""))
    map(parsebank, banks)
end

function highestjoltage(batterybank, digits)
    joltage = 0
    bank = batterybank
    for i in digits-1:-1:0
        (max, pos) = findmax(bank[1:end-i])
        joltage += max * 10 ^ i
        bank = bank[pos+1:end]
    end
    joltage
end

function solvepart1(batterybanks)
    highestjoltage_2digits(bank) = highestjoltage(bank, 2)
    sum(map(highestjoltage_2digits, batterybanks))
end

function solvepart2(batterybanks)
    highestjoltage_12digits(bank) = highestjoltage(bank, 12)
    sum(map(highestjoltage_12digits, batterybanks))
end

puzzles = [
    Puzzle(03, "test 1", "test.txt", solvepart1, 357),
    Puzzle(03, "deel 1", solvepart1, 17229),
    Puzzle(03, "test 2", "test.txt", solvepart2, 3121910778619),
    Puzzle(03, "deel 2", solvepart2, 170520923035051)
]

printresults(puzzles)

end