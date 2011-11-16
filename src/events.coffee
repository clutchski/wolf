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

    # Unbind one or many callbacks. If callback is null, remove all callbacks
    # for the given event. If event is null, remove all callbacks for all
    # events. If neither are null, remove the given callback.
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

    # Trigger the given named event. Any additional arguments will be passed to 
    # the bound callback functions.
    trigger : (event) ->
        callbacks = @_callbacks?[event] || []
        args = Array::slice.call(arguments, 1)
        (c.apply(this, args) for c in callbacks when c?)
        return this