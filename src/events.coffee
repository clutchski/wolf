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

    unbind : () ->

    trigger : (event) ->
        callbacks = @_callbacks?[event] || []
        for callback in callbacks
            args = Array::slice.call(arguments, 1)
            callback.apply(null, args)
