import Foundation
import XCTest
import Nimble

final class BasicExampleTests: XCTestCase {
	func test_WhenFooBecomesBar_DoesTheStuff() {
		print("prepare stuff")
		print("prepare more stuff")
		
		expect(true).to(beTrue())
		expect(false).to(beFalse())
	}
}
