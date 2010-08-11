
/**
 * A byte. Not a char - die, C, die.
 */
Byte: cover from char

/**
 * An UTF-32 character
 */
Char: cover from int32_t {

    print: func {
        dst := gc_malloc(4) // 4 bytes long
        length := utf8proc_encode_char(this, dst)
        fwrite(dst, 1, length, stdout)
    }

    println: func {
        print()
        fwrite("\n", 1, 1, stdout)
    }

}

/**
 * Abstract class for all types of Strings
 *
 * The default string type is UTF8String
 */
String: abstract class implements Iterable<Char> {

    size: SizeT {
        get { _getSize() }
    }

    /** the number of bytes in this string */
    _getSize: abstract func -> SizeT

    bytes: Byte* {
        get { _getBytes() }
    }

    /** return the contents of this String, as an array of bytes, UTF-8 encoded */
    _getBytes: abstract func -> Byte*

    /** print *this* followed by a newline. */
    println: func {
        print()
        fwrite("\n", 1, 1, stdout)
    }

    /** print *this* followed by a newline. */
    print: abstract func

    /** allocate a String of length */
    alloc: abstract static func (length: SizeT) -> This

    /** return a string formatted using *this* as template. */
    format: final func (...) -> This {
        list: VaList

        va_start(list, this)
        data := bytes

        // compute length
        length := vsnprintf(null, 0, data, list)
        output := ASCIIString alloc(length)
        va_end(list)

        // now do the actual formatting
        va_start(list, this)
        vsnprintf(output _data, length + 1, data, list)
        va_end(list)

        output
    }

}

/**
 * A fixed-length, immutable ASCII string
 *
 * For a String that handles UTF-8 characters properly (e.g.
 * for 'each', 'size', etc.), see UTF8String
 */
ASCIIString: class extends String {

    _data: Byte*
    _size: SizeT

    _getBytes: func -> Byte* {
        _data
    }

    _getSize: func -> SizeT {
        _size
    }

    /**
     * Allocates a String
     * @param _size The number of bytes of the string
     */
    alloc: static func (._size) -> This {
        this := new()
        this _data = gc_malloc(_size)
        this _size = _size
        this
    }

    /**
     * Creates a new ASCIIString from a null-terminated ASCII string.
     */
    fromNull: static func (data: Pointer, length: Int) -> This {
        this := alloc(length)
        memcpy(this _data, data, length)
        this
    }

    /**
     * Print this
     */
    print: func {
        fwrite(_data, 1, _size, stdout)
    }

    /** Iterate through this string */
    each: func (f: Func (Char)) {
        size times(|i|
            f(_data[i] as Char)
        )
    }

}

/**
 * An fixed-length, immutable UTF-8
 */
UTF8String: class extends String {

    _data: Byte*
    _size: SizeT

    _getBytes: func -> Byte* {
        _data
    }

    _getSize: func -> SizeT {
        _size
    }

    /**
     * Allocates a String
     * @param _size The number of bytes in the string
     */
    alloc: static func (._size) -> This {
        this := new()
        this _data = gc_malloc(_size)
        this _size = _size
        this
    }

    /**
     * Creates a new UTF8String from a null-terminated UTF-8 string.
     */
    fromNull: static func (data: Pointer, length: Int) -> This {
        this := alloc(length)
        memcpy(this _data, data, length)
        this
    }

    /** print *this* followed by a newline. */
    print: func {
        fwrite(_data, 1, _size, stdout)
    }

    /** Iterate through this string */
    each: func (f: Func (Char)) {
        pointer := _data as UInt8*
        bytesRemaining := _size

        codepoint: Char
        while (bytesRemaining) {
            bytesRead := utf8proc_iterate(pointer, bytesRemaining, codepoint&)
            f(codepoint)
            bytesRemaining -= bytesRead // countdown bytesRemaining to 0
            pointer        += bytesRead // advance pointer by the number of read bytes
        }
    }

}


/* ----- UTF-8 handling ----- */

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

/**
 *  utf8proc.h -
 *
 *  Encodes the unicode char with the code point 'uc' as an UTF-8 string in
 *  the byte array being pointed to by 'dst'. This array has to be at least
 *  4 bytes long.
 *  In case of success the number of bytes written is returned,
 *  otherwise 0.
 *  This function does not check if 'uc' is a valid unicode code point.
 */
utf8proc_encode_char: extern func (uc: Char, dst: UInt8*) -> SizeT


/* ----- C interfacing ----- */

include stdint // for uint32_t

include stdio, string

/** stdio.h - formatted print into a buffer, with a specified max length. Returns the actual length of the formatting. */
vsnprintf: extern func (buffer: Byte*, length: Int, fmt: Byte*, args: VaList) -> Int

/** stdio.h - prints a string of bytes to stdout and a newline after it */
puts: extern func (str: Byte*)

/** stdio.h - write a string of bytes to a CFile, nmemb elements of size 'size' */
fwrite: extern func (str: Byte*, size: SizeT, nmemb: SizeT, file: CFile)

/** stdio.h - length of a nul-terminated string */
strlen: extern func (str: Byte*) -> SizeT

operator implicit as (str: String) -> Byte* {
    str bytes
}











