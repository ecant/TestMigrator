import Foundation
import Nimble
import Quick

final class NestedExampleSpec: QuickSpec {
    override class func spec() {
        beforeEach {
            print("top-level setup")
        }

        describe("when foo becomes bar") {
            let somethingInScope = true

            justBeforeEach {
                print("Stuff right before each test")
            }

            beforeEach {
                print("prepare stuff")
                print(somethingInScope)
            }

            afterEach {
                print("clean foo")
            }

            it("does the stuff") {
                expect(true).to(beTrue())
                expect(false).to(beFalse())
            }

            context("and the service fails") {
                let somethingDeeperInScope = true

                beforeEach {
                    print("fake the service")
                }

                justBeforeEach {
                    print("MOOAR stuff right before this test")
                }

                beforeEach {
                    print(somethingDeeperInScope)
                }

                justBeforeEach {
                    print("LAST stuff right before this test")
                }

                afterEach {
                    print("clean up the things")
                }

                it("logs the error message") {
                    expect("").to(beEmpty())
                }
            }
        }
    }
}
