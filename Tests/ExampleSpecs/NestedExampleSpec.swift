import Foundation
import Quick
import Nimble

final class NestedExampleSpec: QuickSpec {
    override class func spec() {
        beforeEach {
            print("top-level setup")
        }
        
        describe("when foo becomes bar") {
            let somethingInScope = true
            
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
                
                beforeEach {
                    print(somethingDeeperInScope)
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
