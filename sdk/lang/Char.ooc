
/**
 * An UTF-32 character
 *
 * @author Amos Wenger (nddrylliog)
 */
Char: cover from int32_t {

    /** Print this character to the standard output stream */
    print: func {
        dst: UInt32 // an UInt32 is 4 UInt8 - that's a naughty hack for performance
        numBytes := utf8proc_encode_char(this, dst& as UInt8*)
        fwrite(dst& as Byte*, 1, numBytes, stdout)
    }

    /** Print this character followed by a newline to the standard output stream */
    println: func {
        print()
        '\n' print()
    }

}

/* ----- C interfacing - utf8proc library ----- */

use utf8proc

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