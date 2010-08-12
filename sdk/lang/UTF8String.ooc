

/**
 * A fixed-length, immutable UTF-8 encoded string
 *
 * @author Amos Wenger (nddrylliog)
 */
UTF8String: class extends String {

    /** In UTF-8, characters can take from 1 to 4 bytes. */
    _data: Byte*

    /**
     * Size of this string in bytes. In UTF-8, the number of characters may be
     * fewer than the numbers of bytes used to store the string, because of >1 bytes
     * sequences used to store a single non-ASCII character. The only way to get
     * the real length of a String is iterate through it
     */
    _numBytes: SizeT

    /**
     * Since UTF-8 strings are immutable, the number of characters can be
     * computed in the fromNull call and cached so we don't have to iterate
     * everytime to find it out
     */
    _numChars: SizeT

    /** return the contents of this String, as an array of bytes, UTF-8 encoded */
    bytes: Byte* {
        get { _data }
    }

    _getNumBytes: func -> SizeT {
        _numBytes
    }

    _getNumChars: func -> SizeT {
        _numChars
    }

    /**
     * Allocates an UTF-8 String with a fixed capacity
     * @param _size The number of bytes in the string
     */
    _alloc: static func (._numBytes) -> This {
        this := new()
        this _data = gc_malloc(_numBytes)
        this _numBytes = _numBytes
        this
    }

    /**
     * Creates a new UTF8String from a null-terminated UTF-8 string.
     */
    fromNull: static func (data: Pointer, numBytes: SizeT) -> This {
        this := _alloc(numBytes)
        memcpy(this _data, data, numBytes)
        this _computeNumChars()
        this
    }

    _computeNumChars: func {
        _numChars = 0
        this each(|c| _numChars += 1)
    }

    /** Print this string to stdout */
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

    toUTF8: func -> This { this }

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


