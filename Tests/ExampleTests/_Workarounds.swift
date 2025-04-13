/// These functions are purely to satisfy the compiler for any Nimble expects that appear in `ExampleTests`.
/// We're removing Nimble imports, which will cause real compiler errors for Nimble's `expect()` calls in Swift Testing,
/// but we want to be able to run these unit tests to validate their transformed syntax.
func expect(_ param: Any) -> Expect {
    Expect()
}

struct Expect {
    func to(_ predicate: Bool) {}
}

func beFalse() -> Bool { true }
func beTrue() -> Bool { true }
func beEmpty() -> Bool { true }

/// These functions are to satisfy the compiler for Quick Behavior subclasses and `itBehavesLike`.
func itBehavesLike<T>(_ behaviorType: T.Type, context: () -> SharedBehaviorArguments) {}
typealias SharedBehaviorArguments = (doStuff: (String) -> Void, name: String)
struct SharedBehavior {}
