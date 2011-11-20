#
# A version of Asteroids written in Wolf.
#


# The ship piloted by the player.
class Ship extends wolf.Rectangle

    @key : 'Ship'

    constructor : (opts = {}) ->
        opts.height ?= 20
        opts.width ?= 20
        opts.direction ?= new wolf.Vector(0, -1)
        opts.speed ?= 0.1
        opts.orientation ?= 90
        super(opts)

   
    # Return a bullet fired by the ship.
    shootBullet : () ->
        bullet = new Bullet(
            x: @x,
            y: @y - @height,
            direction: @direction.copy()
        )

    # Apply the shift's thrusters.
    thrust : () ->
        impulse = @direction.scale(0.5)
        @applyImpulse(impulse)

    # Jump to a random point on screen.
    jumpIntoHyperspace : (xmax, ymax) ->
        x = Math.random() * xmax
        y = Math.random() * ymax

# Asteroids floating around space.
class Asteroid extends wolf.Circle
    
    @key : 'Asteroid'

    constructor : (opts = {}) ->
        defaults =
            x: wolf.random(0, 800)
            y: wolf.random(0, 600)
            radius: 10
            speed: 0.2
            direction: new wolf.Vector(wolf.random(-1, 1), wolf.random(-1, 1))
            dragCoefficient: 0

        opts = wolf.defaults(opts, defaults)
        super(opts)

# Enemy ships trying to kill you.
class EnemyShip extends Ship

    @key : 'EnemyShip'

    constructor : (opts = {}) ->
        opts.height = 20
        opts.width = 20
        super(opts)

# Bullets kill things!
class Bullet extends wolf.Circle

    @key : 'Bullet'

    constructor : (opts={}) ->
        opts.radius = 5
        opts.speed = 1.5
        opts.dragCoefficient = 0
        super(opts)

#
# Create the engine.
#

engine = new wolf.Engine("example")
engine.environment.gravitationalConstant = 0 # Since this an overhead 2d game.

# Create the plane.
ship = new Ship({x: 200, y:200, speed:0.05, direction: new wolf.Vector(0, -1)})

# Create some asteroids.
asteroids = (new Asteroid() for i in [1..10])

# Add them to the engine.
engine.add(ship)
#(engine.add(a) for a in asteroids)


# Attach behaviours.
$(document).keydown (event) ->

    behaviours =
        38 : () ->
            ship.thrust()
        #32 : shoot
        #81 : toggle
        #80 : report

    key = event.which || event.keyCode
    console.log(key)

    callback = behaviours[key]
    callback() if callback

# Export start and stop to global scope.
this.asteroids =

    engine: engine

    run : () ->
        engine.start()
        engine.toggle()


