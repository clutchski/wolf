#
# An interface to the browser's console log.
#


#= require wolf

class wolf.Logger

    constructor : (module) ->
        @module = module

    # Log a message at the debug level.
    debug : (message) ->
        @log("DEBUG", message)

    # Log a message at the info level.
    info : (message) ->
        @log("INFO", message)

    # Log the message at the given level.
    log : (level, message) ->
        if console
            fields = [new Date().toString(), level, @module, message]
            console.log(fields.join(" | "))
        this
