###

Wolf - An HTML5 Canvas game engine.

Copyright 2011, Matthew Perpick.
Wolf is freely distributable under the MIT license.

https://github.com/clutchski/wolf

###


#= require_self
#= require_tree .


# The wolf global object.
wolf = {}

# Export wolf to global scope.
this.wolf = wolf

# The current version.
wolf.VERSION = "0.0.0"


# Copy the properties of the source objects to the destination object.
wolf.extend = (destination, sources...) ->
    for source in sources
        (destination[k] = v for k, v of source)
    return destination

# Return a unique id, with an optional prefix.
wolf.getUniqueId = do ->
    id = 0
    return (prefix="") ->
        id += 1
        return prefix + id

# Patch any missing properties from defaults to options and return
# the resulting object.
wolf.defaults = (options, defaults) ->
    return wolf.extend({}, defaults, options)
    
