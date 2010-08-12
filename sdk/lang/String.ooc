
/**
 * A byte, ie. 8 bits.
 * *Not* a char (die, C, die)
 *
 * @author Amos Wenger (nddrylliog)
 */
Byte: cover from char

/**
 * Abstract class for all types of Strings
 *
 * The default string type is UTF8String
 *
 * @author Amos Wenger (nddrylliog)
 */
String: abstract class implements Iterable<Char> {

    toNull: func -> Byte* {
        toUTF8() bytes
    }

    /** Number of bytes used to store this string */
    numBytes: SizeT {
        get { _getNumBytes() }
    }
    _getNumBytes: abstract func -> SizeT

    /**
     * Number of characters in this string
     *
     * 'character' is a tricky notion in Unicode. We assume that a 'grapheme cluster'
     * as defined in utf8proc, the UTF-8 library used in this sdk, corresponds to
     * one character.
     *
     * For more details, please refer to the utf8proc documentation or its sourcecode.
     */
    numChars: SizeT {
        get { _getNumChars() }
    }
    _getNumChars: abstract func -> SizeT

    /** print *this* followed by a newline. */
    println: func {
        print()
        fwrite("\n", 1, 1, stdout)
    }

    /** print *this* followed by a newline. */
    print: abstract func

    /** return a string formatted using *this* as template. */
    format: final func (...) -> This {
        list: VaList

        va_start(list, this)
        data := toUTF8() bytes

        // compute length
        numBytes := vsnprintf(null, 0, data, list)
        output := gc_malloc(numBytes + 1)
        va_end(list)

        // now do the actual formatting
        va_start(list, this)
        vsnprintf(output, numBytes + 1, data, list)
        va_end(list)

        UTF8String fromNullZeroCopy(output, numBytes)
    }

    /**
     * Return a String guaranteed to be of internal encoding UTF-8.
     * This is useful if you often use 'bytes' and can't afford multiple
     * conversion from UTF-32 (aka UCS-2), for example.
     *
     * Returning an ASCIIString is acceptable, since it's a subset of UTF-8
     */
    toUTF8: abstract func -> UTF8String

    /**
     * Return a String guaranteed to be of internal encoding UTF-32 (aka UCS-2)
     */
    toUTF32: abstract func -> UTF32String

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
    str toNull()
}











