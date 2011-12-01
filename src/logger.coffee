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

    # Log the message at the given level.
    write : (level, message) ->
        if console
            fields = [new Date().toString(), level, @module, message]
            console.log(fields.join(" | "))
        this
