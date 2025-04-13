import Nimble
import Quick

final class BehaviorExampleSpec: QuickSpec {
    override class func spec() {
        it("does a thing") {
            expect(true).to(beTrue())
        }

        itBehavesLike(
            SharedBehavior.self,
            context: {
                SharedBehaviorArguments(doStuff: ({ _ in }), name: "one")
            })

        describe("When in example two") {
            itBehavesLike(
                SharedBehavior.self,
                context: {
                    SharedBehaviorArguments(doStuff: ({ _ in }), name: "two")
                })

        }
    }
}
