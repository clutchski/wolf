###

Timber - An HTML5 Canvas game engine.

Copyright 2011, Matthew Perpick.
Timber is freely distributable under the MIT license.

https://github.com/clutchski/timber

###


#= require_self
#= require_tree .


# The timber global object.
timber = {}

# Export timber to global scope.
this.timber = timber

# The current version.
timber.VERSION = "0.0.0"


# Copy the properties of the source objects to the destination object.
timber.extend = (destination, sources...) ->
    for source in sources
        (destination[k] = v for k, v of source)
    return destination

# Return a unique id, with an optional prefix.
timber.getUniqueId = (() ->
    id = 0
    return (prefix="") ->
        id += 1
        return prefix + id
)()

# Patch any missing properties from defaults to options and return
# the resulting object.
timber.defaults = (options, defaults) ->
    return timber.extend({}, defaults, options)
    
