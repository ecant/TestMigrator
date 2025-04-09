import Foundation
import Nimble
import XCTest

final class NestedExampleTests: XCTestCase {
	override func setUp() {
		super.setUp()

		print("top-level setup")
	}

	func test_whenFooBecomesBar_doesTheStuff() {
		let somethingInScope = true

		print("prepare stuff")
		print(somethingInScope)

		print("Stuff right before each test")

		expect(true).to(beTrue())
		expect(false).to(beFalse())

		print("clean foo")
	}

	func test_whenFooBecomesBar_andTheServiceFails_logsTheErrorMessage() {
		let somethingInScope = true

		let somethingDeeperInScope = true

		print("prepare stuff")
		print(somethingInScope)

		print("fake the service")

		print(somethingDeeperInScope)

		print("Stuff right before each test")

		print("MOOAR stuff right before this test")

		print("LAST stuff right before this test")

		expect("").to(beEmpty())

		print("clean up the things")

		print("clean foo")
	}
}
