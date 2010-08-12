

/**
 * A fixed-length, immutable UTF-8 encoded string
 *
 * @author Amos Wenger (nddrylliog)
 */
UTF8String: class extends String {

    buffer: UTF8Buffer

    /** return the contents of this String, as an array of bytes, UTF-8 encoded */
    bytes: Byte* {
        get { buffer bytes }
    }

    /**
     * Since UTF-8 strings are immutable, the number of characters can be
     * computed in the fromNull call and cached so we don't have to iterate
     * everytime to find it out
     */
    _numChars: SizeT

    _getNumBytes: func -> SizeT {
        buffer numBytes
    }

    _getNumChars: func -> SizeT {
        _numChars
    }

    /**
     * Create a new UTF8String from an UTF8Buffer
     */
    fromBuffer: static func (buffer: UTF8Buffer) -> This {
        this := new()
        this buffer = buffer
        // since we're immutable, we can cache the result of numChars here
        this _numChars = buffer _getNumChars()
        this
    }

    /**
     * Create a new UTF8String from a null-terminated UTF-8 string.
     */
    fromNullZeroCopy: static func (data: Pointer, numBytes: SizeT) -> This {
        fromBuffer(UTF8Buffer fromNullZeroCopy(data, numBytes))
    }

    /**
     * Create a new UTF8String from a null-terminated UTF-8 string.
     */
    fromNull: static func (data: Pointer, numBytes: SizeT) -> This {
        fromBuffer(UTF8Buffer fromNull(data, numBytes))
    }

    fromNull: static func ~implicitLength (data: Pointer) -> This {
        fromNull(data, strlen(data))
    }

    /** Print this string to the standar output stream */
    print: func {
        buffer print()
    }

    /** Iterate through this string */
    each: func (f: Func (Char)) {
        buffer each(f)
    }

    toUTF8: func -> This {
        this
    }

    toUTF32: func -> UTF32String {
        UTF32String fromNull(toNull(), numBytes)
    }

}



/* ----- C interfacing - utf8proc library ----- */

use utf8proc

/**
 *  utf8proc.h -
 *
 *  Reads a single char from the UTF-8 sequence being pointed to by 'str'.
 *  The maximum number of bytes read is 'strlen', unless 'strlen' is
 *  negative.
 *  If a valid unicode char could be read, it is stored in the variable
 *  being pointed to by 'dst', otherwise that variable will be set to -1.
 *  In case of success the number of bytes read is returned, otherwise a
 *  negative error code is returned.
 */
utf8proc_iterate: extern func (str: UInt8*, strlen: SizeT, dst: Char*) -> SizeT


