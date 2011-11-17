
module "CollisionHandler"

Rectangle = wolf.Rectangle
Vector = wolf.Vector

test "detectCollisions", () ->
    ch = new wolf.CollisionHandler()

    r1 = new Rectangle({x:0,    y:0,    width:10,  height:10})
    r2 = new Rectangle({x:0,    y:0,    width:100, height:100})
    r3 = new Rectangle({x:150,  y:150,  width:100, height:100})
    r4 = new Rectangle({x:50,   y:50,   width:100, height:100})
    r5 = new Rectangle({x:50,   y:150,  width:100, height:100})
    r6 = new Rectangle({x:500,  y:500,  width:100, height:100})

    equals(ch.detectCollisions([]).length, 0, "no elements")
    equals(ch.detectCollisions([r1]).length, 0, "one element")
    equals(ch.detectCollisions([r1, r3, r6]).length, 0, "no collisions")

    collisions = ch.detectCollisions([r1, r2])
    equals(collisions.length, 1, "found one collision")

    collisions = ch.detectCollisions([r1, r2, r3, r4, r5, r6])
    equals(collisions.length, 5, "found five collisions")

test "detectCollision", () ->
    r1 = new Rectangle({x:0, y:0, width:10, height: 10})
    r2 = new Rectangle({x:0, y:0, width:100, height: 100})
    r3 = new Rectangle({x:20, y:20, width:100, height: 100})

    ch = new wolf.CollisionHandler()

    ok(ch.detectCollision(r1, r2), "collision")
    ok(not ch.detectCollision(r1, r3), "no collision")

test "resolveCollision", 7, () ->

    # Assert a collision taht doesn't resolve the collsion still applies the
    # physics.
    r1 = new Rectangle({
        x:0, y:0,
        width:10,
        height: 10,
        speed: 2000,
        direction: new Vector(-1, 0)
    })
    r2 = new Rectangle({
        x:0, y:0, width:100, height: 100,
        direction: new Vector(1, 0), speed:10000
    })

    for e in [r1, r2]
        e.bind 'collided', () ->
            ok(true, 'triggered handler')

    ch = new wolf.CollisionHandler()

    r1StartSpeed = r1.speed
    r2StartSpeed = r2.speed
    ch.elapse([r1, r2], 1000)

    QUnit.ok(r1StartSpeed != r1.speed, "collision applied to r1")
    QUnit.ok(r2StartSpeed != r2.speed, "collision applied to r2")

    # Assert a collision that is resolved with custom handlers doesn't apply
    # physics translations.
    r4 = new Rectangle({
        x:0, y:0,
        width:10,
        height: 10,
        speed: 2000,
        direction: new Vector(-1, 0)
    })
    r3 = new Rectangle({
        x:0, y:0, width:100, height: 100,
        direction: new Vector(1, 0), speed:4000
    })

    r3.bind 'collided', (c) ->
        ok(true, 'called the handler')
        c.resolve()

    r3Start = r3.speed
    r4Start = r4.speed

    ch.elapse([r4, r3], 1000)
    QUnit.equals(r3Start, r3.speed, "r3 didn't move")
    QUnit.equals(r3Start, r3.speed, "r4 didn't move")
