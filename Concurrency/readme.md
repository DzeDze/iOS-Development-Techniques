# Concurrency Using Async Let or Task Group

Starting from iOS 15, we can use async/await to achieve concurrency in Swift. There are two common techniques for running tasks in parallel and awaiting their results: **Async Let** and **Task Group**.

### Async Let
Use **async let** when you know exactly how many concurrent tasks you need. This technique offers a simple and more readable way to handle concurrency. However, it has limitations in terms of error handling and task cancellation.

Example:

```swift
func fetchImagesAndQuotes() async throws {
    async let imageData: Data = fetchImage()
    async let quoteData: Data = fetchQuote()

    let image = try await imageData
    let quote = try await quoteData
    
    // Use image and quote
}
```
### Task Group
Use **task groups** when you need to handle a dynamic number of tasks (including an arbitrary number of tasks created at runtime), require more control over execution and error handling, or want to manage the lifetime of tasks more explicitly.

Example:

```swift
func fetchMultipleImagesAndQuotes(amount: Int) async throws -> [QuoteImage] {
    var quoteImages: [QuoteImage] = []
    
    try await withThrowingTaskGroup(of: QuoteImage.self) { group in
        for _ in 0..<amount {
            group.addTask {
                let imageData = try await fetchImage()
                let quoteData = try await fetchQuote()
                return QuoteImage(imageData: imageData, quoteData: quoteData)
            }
        }

        for try await quoteImage in group {
            quoteImages.append(quoteImage)
        }
    }
    
    return quoteImages
}
```
### Demo

This simple app demonstrates how to use both techniques to fetch multiple random images and quotes in parallel. The results are then bound to a table view one by one as soon as each pair of an image and a quote is fetched.

### Network.swift
**Async Let**: 
```swift 
func getQuoteImageUsingAsyncLet() async throws -> QuoteImage
```
**Task Group**: 
```swift
func getQuoteImageUsingTaskGroup() async throws -> QuoteImage
```