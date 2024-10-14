# Race Condition: The Bank Withdrawal Problem

**The Bank Withdrawal Problem** can be seen as a classic example of a **race condition**, where two or more concurrent tasks attempt to modify a value simultaneously.

```swift
struct BankAccount {
    
    private var balance: Double
   
    init(balance: Double) {
        self.balance = balance
    }
    mutating func withdraw( _ amount: Double) {
        
        print("Withdrawal Request for $\(amount) Received.")
        if amount <= balance {
            let processingTime = UInt32.random(in: 1...3)
            print("Your current balance is $\(balance)")
            print("Withdrawing estimated time for $\(amount) is \(processingTime) seconds")
            print("Withdrawing $\(amount) from your account...")
            sleep(processingTime)
            balance -= amount
            print("Success! Your balance now is $\(balance)")
        } else {
            print("You do not have sufficient fund to withdraw.")
        }
    }
}

var bankAccount = BankAccount(balance: 6000)

func bankAccountConcurrencyProblem() {
    // Create a DispatchQueue to withdraw from the balance
    // 2 times concurrently to demo the problem
    let queue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)

    queue.async {
        bankAccount.withdraw(3000)
    }

    queue.async {
        bankAccount.withdraw(5000)
    }
} 
```
The console may print something like this:

```
Withdrawal Request for $3000.0 Received.
Withdrawal Request for $5000.0 Received.
Your current balance is $6000.0
Your current balance is $6000.0
Withdrawing estimated time for $3000.0 is 3 seconds
Withdrawing estimated time for $5000.0 is 1 seconds
Withdrawing $3000.0 from your account...
Withdrawing $5000.0 from your account...
Success! Your balance now is $1000.0
Success! Your balance now is $-2000.0
```

### Solve the Problem using SerialQueue

```swift
let queue = DispatchQueue(label: "SerialQueue")

queue.async {
	bankAccount.withdraw(3000)
}

queue.async {
	bankAccount.withdraw(5000)
}
```
Now the console should print like this:

```
Withdrawal Request for $3000.0 Received.
Your current balance is $6000.0
Withdrawing estimated time for $3000.0 is 3 seconds
Withdrawing $3000.0 from your account...
Success! Your balance now is $3000.0
Withdrawal Request for $5000.0 Received.
You do not have sufficient fund to withdraw.
```
### Solve the Problem using Lock
Modify BankAccount struct with Lock

```swift
struct BankAccount {
    
    private var balance: Double
    private var lock = NSLock()
    init(balance: Double) {
        self.balance = balance
    }
    mutating func withdraw( _ amount: Double) {
        lock.lock()
        // Defer: A block of code marked with defer will be executed
        // after all other codethe current scope has finished, but before the scope is exited.
        defer { lock.unlock() }
        print("Withdrawal Request for $\(amount) Received.")
        if amount <= balance {
            let processingTime = UInt32.random(in: 1...3)
            print("Your current balance is $\(balance)")
            print("Withdrawing estimated time for $\(amount) is \(processingTime) seconds")
            print("Withdrawing $\(amount) from your account...")
            sleep(processingTime)
            balance -= amount
            print("Success! Your balance now is $\(balance)")
        } else {
            print("You do not have sufficient fund to withdraw.")
        }
    }
}
```