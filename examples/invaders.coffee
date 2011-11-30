#
# A version of space invaders written with Wolf.
#


# The invaders namespace.
invaders = {}

# Export to global scope.
this.invaders = invaders


#
# Elements.
#


# The ship piloted by the player.
class Ship extends wolf.Polygon

    constructor : (opts = {}) ->
        shape  = [[0, 0], [-15, -35], [-30, 0]]
        opts.vertices = (new wolf.Point(a+opts.x, b+opts.y) for [a, b] in shape)
        super(opts)

    # Return a bullet fired by the ship.
    shootBullet : () ->
        position = @getCenter().add(new wolf.Point(0, -30))
        bullet = new Bullet(
            x: position.x
            y: position.y
        )

    # Move the ship in the given direction.
    move : (direction) ->
        impulse = direction.scale(0.3)
        @applyImpulse(impulse)

    # Move the ship up.
    moveUp : () ->
        @move(new wolf.Vector(0, -1))

    # Move the ship down.
    moveLeft : () ->
        @move(new wolf.Vector(-1, 0))

    # Move the ship right.
    moveRight : () ->
        @move(new wolf.Vector(1, 0))

    # Move the ship down.
    moveDown : () ->
        @move(new wolf.Vector(0, 1))


# The enemies that attack the player.
class Enemy extends wolf.Rectangle

    constructor : () ->
        opts =
            x: Math.random() * 800
            y: 100
            direction: new wolf.Vector(0, 1)
            speed: Math.random() * 0.5
            width: 20
            height: 20
            dragCoefficient: 0
        super(opts)

# Bullets kill things!
class Bullet extends wolf.Circle

    constructor : (opts={}) ->
        opts.radius = 5
        opts.speed = 1.5
        opts.dragCoefficient = 0
        opts.direction = new wolf.Vector(0, -1) # Bullets shoot up.
        super(opts)
        @bind 'collided', (collision, other) ->
            if other instanceof Enemy
                other.destroy()
                @destroy()


#
# Initialize the game.
#

engine = null


initialize = () ->
    engine = new wolf.Engine("example")
    engine.environment.gravitationalConstant = 0 # Since this an overhead 2d game.

    # Create the ship.
    ship = new Ship({x:200, y:200})
    engine.add(ship)

    # Initialize the user input commands.
    commands =
        37 : () ->
            ship.moveLeft()
        39 : () ->
            ship.moveRight()
        38 : () ->
            ship.moveUp()
        40 : () ->
            ship.moveDown()
        32 : () ->
            bullet = ship.shootBullet()
            engine.add(bullet)
        81 : () ->
            engine.toggle()
        80 : () ->
            engine.logStatusReport()

    $(document).keydown (event) ->
        key = event.which || event.keyCode
        callback = commands[key]
        console.log('aaa')
        callback() if callback

    engine.start()

    createEnemies = () ->
        enemy = new Enemy()
        engine.add(enemy)
        if engine.isRunning
            setTimeout(() ->
                createEnemies()
            , 1000)
    createEnemies()


invaders.run = () ->
    initialize()

invaders.stop = () ->
    engine.stop()
    engine = null
