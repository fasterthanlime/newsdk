

/**
 * A fixed-length, immutable ASCII string
 *
 * For a String that handles UTF-8 characters properly (e.g.
 * for 'each', 'size', etc.), see UTF8String
 *
 * @author Amos Wenger (nddrylliog)
 */
ASCIIString: class extends UTF8String {

    _getNumChars: func -> SizeT {
        /* chars = bytes in ASCII. */
        _numBytes
    }

    /**
     * Allocates an ASCII String with a fixed capacity
     * @param _size The number of bytes of the string
     */
    _alloc: static func (._numBytes) -> This {
        this := new()
        this _data = gc_malloc(_numBytes)
        this _numBytes = _numBytes
        this
    }

    /**
     * Creates a new ASCIIString from a null-terminated UTF-8 string.
     *
     * If the 'data' pointer contains non-ASCII characters, it will
     * result in garbage. The only way back is to try and call toUTF8()
     */
    fromNull: static func (data: Pointer, ._numBytes) -> This {
        this := _alloc(_numBytes)
        memcpy(this _data, data, _numBytes)
        this
    }

    _computeNumChars: func {
        // nothing to do here, ASCII has fixed-width characters
    }

    /** Iterate through this string */
    each: func (f: Func (Char)) {
        numChars times(|i|
            // _data[i] is a Byte, so we're widening it to a Char
            f(_data[i] as Char)
        )
    }

}