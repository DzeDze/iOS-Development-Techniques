# COLLECTION TRANSFORMATION/ MANIPULATION FUNCTIONS

In Swift, map, filter, and reduce are important higher-order functions for collections. They are useful for transforming and/or manipulating collections in a functional programming style.

* **Map**: Used to transform each element of a collection using a closure and return a collection of results

Example

*array*

```swift
let array = [1,2,3,4,5,6]
let map = array.map { $0 + $0 } // [2, 4, 6, 8, 10, 12]
```

*dictionary*
	
```swift
let dictionary = ["one":1, "two": 2, "three": 3, "four": 4, "five": 5, "six": 6]
let map = dictionary.mapValues { $0 + $0 } //["three": 6, "five": 10, "four": 8, "two": 4, "one": 2, "six": 12]
```

* **Filter**: Used to select elements of a collection based on a condition and return a collection containing only those elements that satisfy that condition.

Example
	
*array*

```swift
let filter = array.filter { $0 % 2 == 0} // [2, 4, 6]
```

*dictionary*

```swift
let filter = dictionary.filter { $0.value % 2 == 0 } //["one": 2, "two": 4, "three": 6, "four": 8, "six": 12, "five": 10]
```
* **Reduce**: Used to combine all elements of a collection into a single value using a closure.

Example
	
*array*

```swift
let reduce = array.reduce(1) {$0 + $1} // 22
```

*dictionary*

```swift
let reduce = dictionary.reduce(0) { $0 + $1.value} //21
```

These functions, **map, filter, and reduce**, can also be used together to perform complex operations on collections.

Example
	
*array*

```swift
let combine = array
                .filter { $0 % 2 == 0} //only evens
                .map { $0 * $0 }       //square them
                .reduce(0) { $0 + $1 } //then sum 56
```

*dictionary*

```swift
let combine = dictionary
                .filter{ $0.value % 2 == 0 } //only even values
                .mapValues { $0 * $0 }       //square them
                .reduce(0){ $0 + $1.value }  //sum 56
```
