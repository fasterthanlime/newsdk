

/**
 * Abstract class for all types of Strings
 *
 * The default string type is UTF8String
 *
 * @author Amos Wenger (nddrylliog)
 */
Buffer: abstract class implements Iterable<Char> {

    numBytes: SizeT {
        get { _getNumBytes() }
    }
    _getNumBytes: abstract func -> SizeT

    numChars: SizeT {
        get { _getNumChars() }
    }
    _getNumChars: abstract func -> SizeT

    /** Print this buffer to the standard output stream */
    print: abstract func

}