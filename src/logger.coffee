#
# An interface to the browser's console log.
#


class wolf.Logger

    constructor : (module) ->
        @module = module

    # Log a message at the debug level.
    debug : (message) ->
        @write("DEBUG", message)

    # Log a message at the info level.
    info : (message) ->
        @write("INFO", message)

    write : (level, message) ->
        console.log([level, @module, message].join(" | ")) if console

