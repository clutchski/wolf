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


# Copy the properties of the source object to the destination object.
timber.extend = (destination, source) ->
    (destination[k] = v for k, v of source)
    return destination

# Return a unique id, with an optional prefix.
timber.getUniqueId = (() ->
    id = 0
    return (prefix="") ->
        id += 1
        return prefix + id
)()
