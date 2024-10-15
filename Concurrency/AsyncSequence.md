# Async Sequence

An async sequence is similar to a regular sequence, but instead of providing all its elements at once, an async sequence provides its elements one by one asynchronously. We simply await each element as it becomes available.

In Swift, **Async Sequence** is a protocol like this:

```swift
protocol AsyncSequence {
    associatedtype Element
    func makeAsyncIterator() -> AsyncIterator
}

protocol AsyncIterator {
    mutating func next() async throws -> Element?
}
```
### AsyncStream

Swift also provides built-in async sequences. The most common one is **AsyncStream**, which allows us to convert any callback-based code into an async sequence.

A simple Bingo game implementation below demonstrates how AsyncStream can be used. In the game, a bingo caller randomly calls an Int, while the client also picks a random number. If both numbers match, "Bingo!" is printed, and the game will stop. An AsyncStream is used to capture each bingo call one by one, and the client awaits each call sequentially.

```swift
class Bingo {
    
    var timer: Timer?
    var callHandler: (Int) -> Void = { _ in }
    
    @objc func call() {
        let randomNumber = Int.random(in: 1...16)
        print("Calling \(randomNumber)")
        callHandler(randomNumber)
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(call), userInfo: nil, repeats: true)
    }
    
    func stopGame() {
        timer?.invalidate()
        timer = nil
        print("Game stopped.")
    }
}

let bingo = Bingo()

//buffer 2 oldest value, remove the rest to save memory ;)
let bingoCallStream = AsyncStream(Int.self, bufferingPolicy: .bufferingOldest(2)) { continuation in
    
    bingo.callHandler = { callingNumber in
        continuation.yield(callingNumber)
    }
    bingo.startGame()
    continuation.onTermination = { _ in
        bingo.stopGame()
    }
}

Task {
    for await callingNumber in bingoCallStream {
        let myNumber = Int.random(in: 1...16)
        print("My number is \(myNumber)")
        if myNumber == callingNumber {
            print("Bingo!")
            bingo.stopGame()
            break
        } else {
            print("Missed!")
        }
    }
}
```