#
# Performance Tests
#


# Test fixtures
intervals = ([wolf.random(0, 100), wolf.random(0, 100)] for i in [0..1000])


JSLitmus.test 'intervalIntersects', () ->
    for i in [0..1000]
        for j in [i..1000]
            i1 = intervals[i]
            i2 = intervals[j]
            wolf.intervalIntersects(i1, i2)
