
module "CollisionHandler"

Rectangle = timber.Rectangle

test "detectCollisions", () ->
    ch = new timber.CollisionHandler()

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

    ch = new timber.CollisionHandler()

    ok(ch.detectCollision(r1, r2), "collision")
    ok(not ch.detectCollision(r1, r3), "no collision")
