import Foundation
import Nimble
import Quick

final class BeforeAndAfterExampleSpec: QuickSpec {
    override class func spec() {
        var something: String!

        beforeEach {
            something = ""
            print(something ?? "")
        }

        justBeforeEach {
            print("top-level justBeforeEach")
        }

        afterEach {
            print("top-level teardown")
        }

        let helloWorld = true

        beforeEach {
            print("another top-level setup")
        }

        afterEach {
            print("another top-level teardown")
        }

        it("does the stuff") {
            print(helloWorld)
            expect(true).to(beTrue())
            expect(false).to(beFalse())
        }
    }
}
