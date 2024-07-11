import Foundation
import XCTest
import Nimble

final class NestedExampleTests: XCTestCase {
    override func setUp() {
        super.setUp()

        print("top-level setup")
    }

    func test_WhenFooBecomesBar_DoesTheStuff() {
        let somethingInScope = true
        
        print("prepare stuff")
        print(somethingInScope)

        expect(true).to(beTrue())
        expect(false).to(beFalse())

        print("clean foo")
    }

    func test_WhenFooBecomesBar_AndTheServiceFails_LogsTheErrorMessage() {
        let somethingInScope = true
        
        let somethingDeeperInScope = true
        
        print("prepare stuff")
        print(somethingInScope)

        print("fake the service")
        
        print(somethingDeeperInScope)

        expect("").to(beEmpty())

        print("clean up the things")

        print("clean foo")
    }
}
