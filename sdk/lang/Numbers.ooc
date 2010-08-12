
include stdbool // for bool
include stddef // for size_t
include stdint // for uint8_t (used by generics all over the place)

/**
 * An integer
 */
Int: cover from int {

    odd?:  func -> Bool { this % 2 == 1 }
    even?: func -> Bool { this % 2 == 0 }

    divisor?: func (divisor: Int) -> Bool {
        this % divisor == 0
    }

    in?: func(range: Range) -> Bool {
        (this >= range min) && (this <  range max)
    }

    /**
     * Run 'fn' this many times
     */
    times: func (fn: Func (Int)) {
        for(i in 0..this) {
            fn(i)
        }
    }
}

/**
 * Unsigned int on 8 bits
 */
UInt8: cover from uint8_t extends Int

/**
 * Unsigned int on 16 bits
 */
UInt16: cover from uint16_t extends Int

/**
 * Unsigned int on 32 bits
 */
UInt32: cover from uint32_t extends Int

/**
 * A boolean type
 */
Bool: cover from bool {
    toString: func -> String {
        this ? "true" : "false"
    }
}

/**
 * SizeT can hold the value of any pointer
 */
SizeT: cover from size_t extends Int

/**
 * A range has a lower bound and an upper bound
 */
Range: cover {

    min, max: Int

    init: func@ (=min, =max) {}

    reduce: func (f: Func (Int, Int) -> Int) -> Int {
        acc := f(min, min + 1)
        for(i in min + 2..max) acc = f(acc, i)
        acc
    }

}