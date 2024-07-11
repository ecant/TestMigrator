import Foundation
import XCTest
import Nimble

final class BeforeAndAfterExampleTests: XCTestCase {
    var something: String!
    let helloWorld = true
    
    override func setUp() {
        super.setUp()

        something = ""
        print(something ?? "")
        
        print("another top-level setup")
    }
    
    override func tearDown() {
        super.tearDown()
        
        print("top-level teardown")
        
        print("another top-level teardown")
    }

    func test_DoesTheStuff() {
        print(helloWorld)
        expect(true).to(beTrue())
        expect(false).to(beFalse())
    }
}
