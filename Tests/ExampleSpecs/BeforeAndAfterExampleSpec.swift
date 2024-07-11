import Foundation
import Quick
import Nimble

final class BeforeAndAfterExampleSpec: QuickSpec {
    override class func spec() {
        var something: String!
        
        beforeEach {
            something = ""
            print(something ?? "")
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
