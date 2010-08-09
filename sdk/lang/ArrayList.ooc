
/**
   Resizable-array implementation of the List interface. Implements all
   optional list operations, and permits all elements, including null.

   In addition to implementing the List interface, this class provides
   methods to manipulate the size of the array that is used internally
   to store the list.

   :author: Amos Wenger (nddrylliog)
 */
ArrayList: class <T> implements Iterable<T> {

	data : T*
	capacity : Int
	size : Int { get set }

    /**
     * Create a new empty ArrayList
     */
	init: func {
		init(10)
	}

    /**
     * Create a new ArrayList that can store up to 'capacity'
     * elements without being resized
     */
	init: func ~withCapacity (=capacity) {
		data = gc_malloc(capacity * T size)
	}

    /**
     * Create a new ArrayList from an array, given its size
     */
    init: func ~withData (.data, =size) {
        this data = gc_malloc(size * T size)
        memcpy(this data, data, size * T size)
        capacity = size
    }

    /**
     * Iterate through this ArrayList
     */
    each: func (f: Func (T)) {
        size times(|i|
            f(this[i])
        )
    }

    /**
     * Add `element` at the end of this list
     */
	add: func (element: T) {
		_ensureCapacity(size + 1)
		data[size] = element
		size += 1
	}

    /**
     * Clear this list - remove all elements.
     */
	clear: func {
		size = 0
	}

    /**
     * @return the index-th element
     */
	get: func(index: Int) -> T {
		_checkIndex(index)
		data[index]
	}

	/**
	 * Replaces the element at the specified position in this list with
	 * the specified element.
	 */
	set: func(index: Int, element: T) -> T {
        _checkIndex(index)
        old := data[index]
		data[index] = element
        old
	}
	/**
	 * Increases the capacity of this ArrayList instance, if necessary,
	 * to ensure that it can hold at least the number of elements
	 * specified by the minimum capacity argument.
	 */
	_ensureCapacity: inline func (newSize: Int) {
		if(newSize > capacity) {
			capacity = newSize * (newSize > 50000 ? 2 : 4)
            tmpData := gc_realloc(data, capacity * T size)
            if (!tmpData) {
                Exception new(This, "Failed to allocate %zu bytes of memory for array to grow! Exiting..\n" format(capacity * T size)) throw()
            } else {
                data = tmpData
            }
		}
	}

	/** private */
	_checkIndex: inline func (index: Int) {
		if (index < 0) {
            Exception new(This, "Index too small! %d < 0" format(index)) throw()
        }
		if (index >= size) {
            Exception new(This, "Index too big! %d >= %d" format(index, size)) throw()
        }
	}

}

/* Operators */
operator [] <T> (list: ArrayList<T>, i: Int) -> T { list get(i) }
operator []= <T> (list: ArrayList<T>, i: Int, element: T) { list set(i, element) }
operator += <T> (list: ArrayList<T>, element: T) { list add(element) }
