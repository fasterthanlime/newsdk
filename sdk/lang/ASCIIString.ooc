

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
        numBytes
    }

    /**
     * Create a new ASCIIString from an UTF8Buffer
     */
    fromBuffer: static func (buffer: UTF8Buffer) -> This {
        this := new()
        this buffer = buffer
        this
    }

    /**
     * Creates a new ASCIIString from a null-terminated UTF-8 string.
     *
     * If the 'data' pointer contains non-ASCII characters, it will
     * result in garbage. The only way back is to try and call toUTF8()
     */
    fromNull: static func (data: Pointer, numBytes: SizeT) -> This {
        fromBuffer(UTF8Buffer fromNull(data, numBytes))
    }

    fromNull: static func ~implicitLength (data: Pointer) -> This {
        fromNull(data, strlen(data))
    }

    /** Iterate through this string */
    each: func (f: Func (Char)) {
        // TODO: implement ASCIIBuffer

        /*
        numChars times(|i|
            // _data[i] is a Byte, so we're widening it to a Char
            f(_data[i] as Char)
        )
        */
        buffer each(f)
    }

}