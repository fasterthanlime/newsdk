

/**
 * A fixed-length, immutable ASCII string
 *
 * For a String that handles UTF-8 characters properly (e.g.
 * for 'each', 'size', etc.), see UTF8String
 *
 * @author Amos Wenger (nddrylliog)
 */
UTF32String: class extends String {

    /** In UTF-32, every character takes 4 bytes. We can store any unicode character that way. */
    _data: Char*

    /** Size of this string in characters */
    _numChars: SizeT

    /** return the contents of this String, as an array of bytes, UTF-8 encoded */
    _getBytes: func -> Byte* {
        toUTF8() bytes
    }

    _getNumBytes: func -> SizeT {
        // note: this is not very helpful to the user - is numBytes really needed?
        _numChars * 4
    }

    _getNumChars: func -> SizeT {
        _numChars
    }

    /**
     * Allocates a String
     * @param _size The number of characters
     */
    _alloc: static func (._numChars) -> This {
        this := new()
        this _data = gc_malloc(_numChars * Char size)
        this _numChars = _numChars
        this
    }

    /**
     * Creates a new UTF32String from a null-terminated UTF-8 string.
     *
     * This operation requires to iterate through the UTF-8 string twice
     * (once to figure out the number of characters, another to store
     * them)
     */
    fromNull: static func (data: Pointer, numBytes: SizeT) -> This {
        utf := UTF8String fromNull(data, numBytes)
        this := _alloc(utf numChars)

        // TODO: instead of having a variable, each() should have an
        // optional 'index' parameter. But it should be implemented
        // in Iterable, and for that we need mixins
        i := 0
        utf each(|c|
            this _data[i] = c
            i += 1
        )
        this
    }

    /** Print this string to stdout */
    print: func {
        // at this point it's the simplest thing to do
        // would it be more optimized to use 'bytes' ?
        // this approach has many calls but less allocations
        each(|c| c print())
    }

    /** Iterate through this string */
    each: func (f: Func (Char)) {
        // Most. Straightforward. Method. Ever.
        numChars times(|i|
            f(_data[i])
        )
    }

    toUTF8: func -> UTF8String {
        // TODO: implement UTF8Buffer

        //buff := UTF8Buffer new()
        //each(|c| buff append(c))
        //buff bytes

        null
    }

}