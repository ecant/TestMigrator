import Foundation
import Nimble
import XCTest

final class BasicExampleTests: XCTestCase {
    func test_whenFooBecomesBar_doesTheStuff() async throws {
        print("prepare stuff")
        print("prepare more stuff")

        expect(true).to(beTrue())
        expect(false).to(beFalse())
    }
}
