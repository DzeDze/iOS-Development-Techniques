# CONTINUATION

In some cases, there may be legacy code that relies on callbacks or completion handlers, which we cannot or do not want to modify. We can use continuations as a bridge to adapt that code to the async/await paradigm.

There are two types of continuations:

**CheckedContinuation**: Used for functions that can throw errors. It ensures that the continuation is resumed only once.

**UnsafeContinuation**: Provides more flexibility but requires the developer to manually ensure safety. It should be used with caution.

These continuations can be implemented using ```withCheckedContinuation``` (or ```withCheckedThrowingContinuation``` if the function can throw errors) and ```withUnsafeContinuation```, respectively.

Consider the code below with a completion handler:

```swift

struct Constants {
    static let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
}

struct Post: Decodable {
    let id: Int
    let title: String
}

enum NetworkError: Error {
    case invalidUrl
    case invalidData
    case encodingError
}

func getPosts(completion: @escaping(Result<[Post], NetworkError>)-> Void) {
    guard let url = Constants.url else {
        completion(.failure(.invalidUrl))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data=data, error == nil else {
            completion(.failure(.invalidData))
            return
        }
        do {
            let posts = try JSONDecoder().decode([Post].self, from: data)
            completion(.success(posts))
        } catch {
            completion(.failure(.encodingError))
        }
    }.resume()
}

```

We can use the above completion handler code in the async/await paradigm by wrapping it in a withCheckedThrowingContinuation, as shown below:

```swift

func getPosts() async throws -> [Post] {
    
    return try await withCheckedThrowingContinuation { continuation in
        getPosts { result in
            switch result {
            case .success(let posts):
                continuation.resume(returning: posts)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}

Task {
    let posts = try await getPosts()
    for post in posts {
        print(post.title)
    }
}

```