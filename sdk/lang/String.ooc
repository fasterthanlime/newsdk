
/**
 * A string
 */
String: cover from char* {

    /** print *this* followed by a newline. */
    println: func {
        puts(this)
    }

    /**
     * Allocates a String
     * @param bytes The size of the string
     */
    alloc: static func (bytes: SizeT) -> This {
        // not much more to do
        gc_malloc(bytes)
    }

    /** return a string formatted using *this* as template. */
    format: func (...) -> This {
        list: VaList

        va_start(list, this)

        // compute length
        length := vsnprintf(null, 0, this, list)
        output := alloc(length)
        va_end(list)

        // now do the actual formatting
        va_start(list, this)
        vsnprintf(output, length + 1, this, list)
        va_end(list)

        output
    }

}

/* ----- C interfacing ----- */

include stdio

vsnprintf: extern func (buffer: Pointer, length: Int, fmt: Pointer, args: VaList) -> Int
puts: extern func (str: Pointer)




