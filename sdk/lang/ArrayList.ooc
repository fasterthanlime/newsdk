
/**
   Resizable-array implementation of the List interface. Implements all
   optional list operations, and permits all elements, including null.

   In addition to implementing the List interface, this class provides
   methods to manipulate the size of the array that is used internally
   to store the list.

   :author: Amos Wenger (nddrylliog)
 */
ArrayList: class <T> implements Iterable<T> {

    /**
     * Number of elements contained in that list
     */
    size: Int { get set }

    /**
     * Actual array used for storing elements
     */
	_data: T*

    /**
     * size of the internal array used for storage
     * ie. number of elements we can add before resizing
     */
	_capacity: Int

    /**
     * Create a new empty ArrayList
     */
	init: func {
		init(10)
	}

    /**
     * Create a new ArrayList that can store up to '_capacity'
     * elements without being resized
     */
	init: func ~with_capacity (=_capacity) {
		_data = gc_malloc(_capacity * T size)
	}

    /**
     * Create a new ArrayList from an array, given its size
     */
    init: func ~with_data (._data, =size) {
        this _data = gc_malloc(size * T size)
        memcpy(this _data, _data, size * T size)
        _capacity = size
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
		_data[size] = element
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
		_data[index]
	}

	/**
	 * Replaces the element at the specified position in this list with
	 * the specified element.
	 */
	set: func(index: Int, element: T) -> T {
        _checkIndex(index)
        old := _data[index]
		_data[index] = element
        old
	}
	/**
	 * Increases the _capacity of this ArrayList instance, if necessary,
	 * to ensure that it can hold at least the number of elements
	 * specified by the minimum _capacity argument.
	 */
	_ensureCapacity: func (newSize: Int) {
		if(newSize > _capacity) {
			_capacity = newSize * (newSize > 50000 ? 2 : 4)
            tmp_data := gc_realloc(_data, _capacity * T size)
            if (!tmp_data) {
                Exception new(This, "Failed to allocate %zu bytes of memory for array to grow! Exiting..\n" format(_capacity * T size)) throw()
            } else {
                _data = tmp_data
            }
		}
	}

	/**
     * Check that an index is within the bounds of
     */
	_checkIndex: func (index: Int) {
		if (index < 0)
            Exception new(This, "Index too small! %d < 0" format(index)) throw()
		if (index >= size)
            Exception new(This, "Index too big! %d >= %d" format(index, size)) throw()
	}

}

/* Operators */
operator [] <T> (list: ArrayList<T>, i: Int) -> T { list get(i) }
operator []= <T> (list: ArrayList<T>, i: Int, element: T) { list set(i, element) }
operator += <T> (list: ArrayList<T>, element: T) { list add(element) }
