
include stdbool // for __done__
include ./Array

/**
 * objects
 */
Object: abstract class {

    class: Class

    /// Instance initializer: set default values for a new instance of this class
    __defaults__: func {}

    /// Finalizer: cleans up any objects belonging to this instance
    __destroy__: func {}

    /** return true if *class* is a subclass of *T*. */
    instanceOf?: final func (T: Class) -> Bool {
        if(!this) return false
        class inheritsFrom?(T)
    }

}

Class: abstract class {

    /// Number of octets to allocate for a new instance of this class
    instanceSize: SizeT

    /** Number of octets to allocate to hold an instance of this class
        it's different because for classes, instanceSize may greatly
        vary, but size will always be equal to the size of a Pointer.
        for basic types (e.g. Int, Char, Pointer), size == instanceSize */
    size: SizeT

    /// Human readable representation of the name of this class
    name: String

    /// Pointer to instance of super-class
    super: const Class

    /// Create a new instance of the object of type defined by this class
    alloc: final func ~_class -> Object {
        object := gc_malloc(instanceSize) as Object
        if(object) {
            object class = this
        }
        return object
    }

    inheritsFrom?: final func ~_class (T: Class) -> Bool {
        if(this == T) return true
        return (super ? super inheritsFrom?(T) : false)
    }

}

/**
 * Underlying class below an Array
 */
Array: cover from _lang_array__Array {
    length: extern SizeT
    data: extern Pointer

    free: extern(_lang_array__Array_free) func
}

/**
 * Pointer type
 */
Pointer: cover from void* {
    toString: func -> String { "%p" format(this) }
}

/**
 * Comparable
 */
Comparable: interface {
    compareTo: func<T>(other: T) -> Int
}

/**
 * Closures
 */
Closure: cover {
    thunk  : Pointer
    context: Pointer
}

/** An object storing a value and its class. */
Cell: class <T> {
    val: T

    init: func(=val) {}
}

operator [] <T> (c: Cell<T>, T: Class) -> T {
    if(!c T inheritsFrom?(T)) {
        Exception new(Cell, "Wants a %s, but got a %s" format(T name, c T name))
    }
    c val
}


