#
# Performance Tests
#


# Test fixtures
intervals = ([wolf.random(0, 100), wolf.random(0, 100)] for i in [0..1000])


JSLitmus.test 'intervalIntersects', () ->
    for i1, idx in intervals
        for i2 in intervals[idx..intervals.length]
            wolf.intervalIntersects(i1, i2)
    this
