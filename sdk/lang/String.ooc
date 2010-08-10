
/**
 * A byte. Not a char - die, C, die.
 */
Byte: cover from char

/**
 * An UTF-32 character
 */
Char: cover from uint32_t

/**
 * A string
 */
String: abstract class {

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
    println: abstract func

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
     * @param length The size of the string
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

    /** print *this* followed by a newline. */
    println: func {
        fwrite(_data, 1, _size, stdout)
        fwrite("\n", 1, 1, stdout)
    }

}

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




