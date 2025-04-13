/// These functions are to satisfy the compiler for Quick Behavior subclasses and `itBehavesLike`.
func itBehavesLike<T>(_ behaviorType: T.Type, context: () -> SharedBehaviorArguments) {}
typealias SharedBehaviorArguments = (doStuff: (String) -> Void, name: String)
struct SharedBehavior {}
