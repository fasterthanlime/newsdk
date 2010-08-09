
/**
 * An iterable is a sequence that can be iterated through with
 * an iterator returned by the iterator()  method
 *
 * @author Amos Wenger (nddrylliog)
 */
Iterable: interface <T> {

    /**
     * Call 'f' on every element of this iterable
     */
    each: func (f: Func (T))

}
