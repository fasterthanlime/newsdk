
/**
 * An iterable is a sequence that can be iterated through
 *
 * @author Amos Wenger (nddrylliog)
 */
Iterable: interface <T> {

    /**
     * Call 'f' on every element of this iterable
     */
    each: func (f: Func (T))

}
