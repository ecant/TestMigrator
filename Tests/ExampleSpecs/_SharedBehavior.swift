import Nimble
import Quick

typealias SharedBehaviorArguments = (doStuff: (String) -> Void, name: String)

final class SharedBehavior: Behavior<SharedBehaviorArguments> {
    override class func spec(_ aContext: @escaping () -> SharedBehaviorArguments) {
        var doStuff: ((String) -> Void)!

        beforeEach {
            doStuff = aContext().doStuff
            print(aContext().name)
        }

        context("when calling the service()") {
            beforeEach {
                doStuff("foo")
                print(name)
            }

            it("it does the stuff") {
                expect(true).to(beTrue())
            }
        }
    }
}
