# Task Cancellation & Task.checkCancellation()

To cancel a task, simply call ```task.cancel()```. However, this may not work effectively for long, heavy-duty tasks if ```Task.checkCancellation()``` is not included in the task's implementation.

For simple and quick tasks like the one below, everything will work fine without ```Task.checkCancellation()```

```swift
func performCancellableTask() async throws {
    for i in 1...10 {
        print("Doing step \(i) ...")
        try await Task.sleep(nanoseconds: 500_000_000)
    }
    print("Task Complete.")
}

let task = Task {
    do {
        try await performCancellableTask()
    } catch is CancellationError {
        print("Task was cancelled")
    } catch {
        print("Other error occured: \(error)")
    }
}

// simulate task cancel
Task {
    try await Task.sleep(nanoseconds:2_000_000_000)
    task.cancel()
}

```
But for a long and heavy task, if ```Task.checkCancellation()``` is not used, the task may never be cancelled:

```swift
func performCancellableTask() async throws {
    for i in 1...1_000_000_000 {
        // Manual cancellation check inside a long-running loop
        try Task.checkCancellation()
        
        // Simulate heavy, non-async work
        if i % 100_000 == 0 { print("Processed \(i) items") }
    }
    print("Task completed successfully")
}

let task = Task {
    do {
        try await performCancellableTask()
    } catch is CancellationError {
        print("Task was canceled manually during non-async work.")
    } catch {
        print("Other error occurred: \(error)")
    }
}

Task {
    // Simulate task cancellation after a short delay
    // Ajust the number arcodingly, in faster computer, it may finish the task before 1sec ;)
    try await Task.sleep(nanoseconds: 1_000_000_000)
    task.cancel()
}

```