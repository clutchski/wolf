#
# Performance tests.
#

random = wolf.random

randomInterval = () ->
    return [random(0, 100), random(200, 1000)]

randomCircle =  () ->
    return new wolf.Circle({
        x:random(0, 500)
        y:random(0, 300)
        radius: random(0, 20)
    })

randomPolygon = () ->
    # For now, return squares.
    width = random(20, 100)
    height = random(30, 150)
    x = random(-100, 100)
    y = random(-100, 100)
    return new wolf.Rectangle({x:x, y:y, width:width, height:height})


#
# Test Fixtures.
#

intervals = (randomInterval() for i in [0..1000])
circles = (randomCircle() for i in [0..500])
polygons = (randomPolygon() for i in [0..500])
elements = circles.concat(polygons)


#
# Performance tests.
#


JSLitmus.test 'intervalIntersects', () ->
    for i1, idx in intervals
        for i2 in intervals[idx..intervals.length]
            wolf.intervalIntersects(i1, i2)
    return this


JSLitmus.test 'intersects', () ->
    for e1, idx in elements
        for e2 in elements[idx..elements.length]
            e1.intersects(e2)
    return this

JSLitmus.test 'rotate', () ->
    (p.rotate(random(0, 360)) for p in polygons)
    return this

JSLitmus.test 'Canvas.clear' , () ->
    canvas = new wolf.Canvas('test-canvas')
    (canvas.clear() for i in [0..100])
    this
