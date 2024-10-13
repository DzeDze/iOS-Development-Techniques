# SEQUENCE

In Swift, **Sequence** is a protocol that provides an abstract interface for iterating over its elements one at a time (sequentially). By conforming to the Sequence protocol, a type promises to provide a way to access elements sequentially using an iterator, so it must implement the ```makeIterator()``` method, which returns an **Iterator**. An **Iterator** is a type that can be used to iterate over a sequence of values, typically using the ```next()``` method.

### Sequence Protocol 

```swift
protocal Sequence {
	associatedtype Iterator: IteratorProtocol
	func makeIterator() -> Iterator
}
```

### Iterator Protocol

```swift
protocol IteratorProtocol {
	associatedtype Element
	mutation func next() -> Element?
}
```

**Note**: Collections are Sequences, but it is not necessary that every Sequence is a Collection, such as ```UnfoldSequence```, ```Stream```, ```AnyIterator```, etc.

### Iterating Over a Sequence

*Using for-in loop*

```swift
let numbers = [1, 2, 3, 4, 5]
for number in numbers {
	print(number)
}
```
*Using the iterator*

```swift
let numbers = [1, 2, 3, 4, 5]
var iterator = numbers.makeIterator()

while let number = iterator.next() {
	print (number)
}
```
### Conforming to the Sequence Protocol

We can create a custom sequence by conforming to the Sequence Protocol. To do this, we need to define an **Iterator** type and implement the ```makeIterator()``` method.

**Example**

```swift
struct EvenNumberSequence: Sequence {
    func makeIterator() ->  EvenNumberIterator {
        return EvenNumberIterator()
    }
}

struct EvenNumberIterator: IteratorProtocol {
    var current = 0
    mutating func next() -> Int? {
        //defer keyword make the block run before the scope is existed
        //but after all the code in the scope finished
        defer { current += 2 }
        return current
    }
}

let evenSequence = EvenNumberSequence().prefix(5)
for evenNum in evenSequence {
    print(evenNum)
}
```
Fibonacci using Sequence

```swift
struct FibonacciSequence: Sequence {
    func makeIterator() -> FibonacciIterator {
        FibonacciIterator()
    }
}

struct FibonacciIterator: IteratorProtocol {
    var currentValue = 0
    var nextValue = 1
    mutating func next() -> Int? {
        
        let result = currentValue
        currentValue = nextValue
        nextValue = result + nextValue
        
        return result
    }
}

let fibonacciSequence = FibonacciSequence()

for fibonacci in fibonacciSequence.prefix(10) {
    print(fibonacci)
}
```
