#
# A module to that can be mixed into any object, allowing the object to trigger
# named events. Inspired by code from Backbone.js.
#

timber.Events =

    # Register the callback with the given named event.
    bind : (event, callback) ->
        @_callbacks ?= {}
        @_callbacks[event] ?= []
        @_callbacks[event].push(callback)
        return this

    # Unbind the given callback from the named event.
    unbind : (event=null, callback=null) ->
        @_callbacks ?= {}

        if not event?
            @_callbacks = {}
        else if not callback?
            @_callbacks[event] = []
        else
            callbacks = @_callbacks[event] || []
            (callbacks[i] = null for c, i in callbacks when c? and c == callback)

        return this

    trigger : (event) ->
        callbacks = @_callbacks?[event] || []
        args = Array::slice.call(arguments, 1)
        (c.apply(this, args) for c in callbacks when c?)
        return this
