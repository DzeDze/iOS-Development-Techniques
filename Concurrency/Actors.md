# Actors

**Actors** serve a similar purpose as classes, but they ensure thread-safe access to their mutable members, avoiding concurrency problems such as race conditions. Actors achieve this by isolating access to their mutable members (like properties and methods) within them, allowing only one thread to access the actor at a time using the await keyword.

**Isolated**: By default, every member of an actor is isolated. To access them from outside the actor, we need to use the await keyword.

**Nonisolated**: You can mark a property or method as nonisolated if it does not modify the actor's state, such as a constant or a method that only reads immutable properties. In this case, we don't need to use await to access nonisolated members.

**Global Actors**: These are used to define isolation in a global context. The most common global actor is **```@MainActor```**, which ensures that all code marked with it runs on the main thread. This is particularly useful for updating the UI.

In the **[Bank Withdrawal Problem](https://github.com/DzeDze/iOS-Development-Techniques/blob/main/Concurrency/Race%20Condition-%20The%20Bank%20Withdrawal%20Problem.md)**, to avoid race conditions, we simply need to change the class to an actor.

```swift
actor BankAccount {
    var balance: Double
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func withdraw(_ amount: Double) {
        print("Receive a withdraw request for $\(amount)")
        print("Your current balance is $\(balance)")
        if amount <= balance {
            let randomProcesingTime = UInt32.random(in: 1...3)
            print("Withdrawing $\(amount) in \(randomProcesingTime)s...")
            sleep(randomProcesingTime)
            balance -= amount
            print("Success! Your balance now is \(balance)")
        } else {
            print("You do not have sufficient fund.")
        }
    }
}

let bankAccount = BankAccount(balance: 5000)

Task {
    await bankAccount.withdraw(4000)
}

Task {
    await bankAccount.withdraw(3000)
}
```

Console

```
Receive a withdraw request for $4000.0
Your current balance is $5000.0
Withdrawing $4000.0 in 2s...
Success! Your balance now is 1000.0
Receive a withdraw request for $3000.0
Your current balance is $1000.0
You do not have sufficient fund.
```