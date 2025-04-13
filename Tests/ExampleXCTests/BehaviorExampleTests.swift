import Nimble
import XCTest

final class BehaviorExampleTests: XCTestCase {
    func test_doesAThing() async throws {
        expect(true).to(beTrue())
    }

    func test_itBehavesLikeSharedBehavior() async throws {
        itBehavesLike(
            SharedBehavior.self,
            context: {
                SharedBehaviorArguments(
                    doStuff: ({ _ in
                    }), name: "one")
            })
    }

    func test_whenInExampleTwo_itBehavesLikeSharedBehavior() async throws {
        itBehavesLike(
            SharedBehavior.self,
            context: {
                SharedBehaviorArguments(
                    doStuff: ({ _ in
                    }), name: "two")
            })
    }
}
