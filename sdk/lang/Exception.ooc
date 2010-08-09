

/**
 * Base class for all exceptions that can be thrown
 *
 * @author Amos Wenger (nddrylliog)
 */
Exception: class {

    /** Class which threw the exception. May be null */
    origin: Class

    /** Message associated with this exception. Printed when the exception is thrown. */
    message : String

    /**
     * Create an exception
     *
     * @param origin The class throwing this exception
     * @param message A short text explaning why the exception was thrown
     */
    init: func  (=origin, =message) {}

    /**
     * Create an exception
     *
     * @param message A short text explaning why the exception was thrown
     */
    init: func ~noOrigin (=message) {}


    /**
     * @return the exception's message, nicely formatted
     */
    format: func -> String {
        if(origin)
            "[%s]: %s" format(class name, message)
        else
            "[%s in %s]: %s" format(class name, origin name, message)
    }

    /**
     * Print this exception, with its origin, if specified, and its message
     */
    print: func {
        fprintf(stderr, "%s", format())
    }

    /**
     * Throw this exception
     */
    throw: inline func {
        print()
        fflush(stdout)
        abort()
    }

}


/* ----- C interfacing ----- */

include stdlib, stdio

/** stlib.h - cause abnormal process termination */
abort: extern func

/** stdio.h */
FStream: cover from Int
stdout, stderr, stdin: extern FStream

fprintf: func (stream: FStream, fmt: Pointer, ...)
fflush: func (stream: FStream)




