import Foundation
import Quick
import Nimble

final class BasicExampleSpec: QuickSpec {
    override class func spec() {
        describe("when foo becomes bar") {
            beforeEach {
                print("prepare stuff")
                print("prepare more stuff")
            }

            it("does the stuff") {
                expect(true).to(beTrue())
                expect(false).to(beFalse())
            }
        }
    }
}
