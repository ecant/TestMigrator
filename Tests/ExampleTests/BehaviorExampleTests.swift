import Testing

@Suite struct BehaviorExampleTests {
    @Test func doesAThing() async throws {
        expect(true).to(beTrue())
    }

    @Test func itBehavesLikeSharedBehavior() async throws {
        itBehavesLike(
            SharedBehavior.self,
            context: {
                SharedBehaviorArguments(
                    doStuff: ({ _ in
                    }), name: "one")
            })
    }

    @Test func whenInExampleTwo_itBehavesLikeSharedBehavior() async throws {
        itBehavesLike(
            SharedBehavior.self,
            context: {
                SharedBehaviorArguments(
                    doStuff: ({ _ in
                    }), name: "two")
            })
    }
}
