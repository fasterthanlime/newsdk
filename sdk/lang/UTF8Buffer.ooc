

/**
 * A mutable UTF-8 encoded string
 *
 * @author Amos Wenger (nddrylliog)
 */
UTF8Buffer: class extends Buffer {

    /** In UTF-8, characters can take from 1 to 4 bytes. */
    _data: Byte*

    /** return the contents of this String, as an array of bytes, UTF-8 encoded */
    bytes: Byte* {
        get { _data }
    }

    /**
     * Size of this string in bytes. In UTF-8, the number of characters may be
     * fewer than the numbers of bytes used to store the string, because of >1 bytes
     * sequences used to store a single non-ASCII character. The only way to get
     * the real length of a String is iterate through it
     */
    _numBytes: SizeT

    _getNumBytes: func -> SizeT {
        _numBytes
    }

    _getNumChars: func -> SizeT {
        // the only way to know the number of characters in an UTF-8 string
        // is to iterate through it.
        _numChars := 0 as SizeT
        this each(|c| _numChars += 1)
        _numChars
    }

    /**
     * Creates an empty UTF-8 buffer
     */
    init: func ~empty {
        this _numBytes = 0
    }

    /**
     * Allocates an UTF-8 String with a fixed capacity
     * @param _size The number of bytes in the string
     */
    init: func ~sized (=_numBytes) {
        this _data = gc_malloc(_numBytes)
        this _numBytes = _numBytes
        this
    }

    /**
     * Create a new UTF8Buffer from a null-terminated UTF-8 string.
     */
    fromNullZeroCopy: static func (data: Pointer, ._numBytes) -> This {
        // +1 because we include the null-byte at the end - it's easier that way
        this := new()
        this _data = data
        this
    }

    /**
     * Create a new UTF8Buffer from a null-terminated UTF-8 string.
     */
    fromNull: static func (data: Pointer, ._numBytes) -> This {
        // +1 because we include the null-byte at the end - it's easier that way
        this := new(_numBytes + 1)
        memcpy(this _data, data, _numBytes + 1)
        this
    }

    fromNull: static func ~implicitLength (data: Pointer) -> This {
        fromNull(data, strlen(data))
    }

    /** Print this buffer to the standard output stream */
    print: func {
        // Here, we're assuming the output stream accepts UTF-8 input
        fwrite(_data, 1, _numBytes, stdout)
    }

    /** Iterate through this string */
    each: func (f: Func (Char)) {
        /*
         * Iterating through an UTF-8 string is tricky. Remember, byte != char in UTF-8.
         *
         * What we have to do is call utf8proc_iterate repeatedly (a very lightweight
         * and convenient utf8 lib) which allows to extract UTF-32 characters (on 4 bytes)
         *
         * utf8proc_iterate returns the number of bytes 'consumed' for every character
         * so we can maintain a count of the remaining bytes and know when to stop.
         */
        pointer := _data as UInt8*
        bytesRemaining := _numBytes
        codepoint: Char

        while (bytesRemaining > 0) {
            bytesRead := utf8proc_iterate(pointer, bytesRemaining, codepoint&)
            f(codepoint)
            bytesRemaining -= bytesRead // countdown bytesRemaining to 0
            pointer        += bytesRead // advance pointer by the number of read bytes
        }
    }

}