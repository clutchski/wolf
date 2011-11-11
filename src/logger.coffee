#
# An interface to the browser's console log.
#


class timber.Logger

    # Create a timber logger.
    #
    # @param module {String} an identifier for the logger
    constructor : (module) ->
        @module = module

    # Log a message at the debug level.
    #
    # @param message {String} the message to log.
    debug : (message) ->
        @_write("DEBUG", message)

    # Log a message at the info level.
    #
    # @param message {String} the message to log.
    info : (message) ->
        @_write("INFO", message)

    _write : (level, message) ->
        console.log([level, @module, message].join(" | ")) if console

