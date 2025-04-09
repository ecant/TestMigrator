import Foundation
import Testing

@Suite struct NestedExampleTests {
	init() {
		print("top-level setup")
	}

	@Test func test_whenFooBecomesBar_doesTheStuff() {
		let somethingInScope = true

		print("prepare stuff")
		print(somethingInScope)

		print("Stuff right before each test")

		// Convert to `#expect`: expect(true).to(beTrue())
		// Convert to `#expect`: expect(false).to(beFalse())

		print("clean foo")
	}

	@Test func test_whenFooBecomesBar_andTheServiceFails_logsTheErrorMessage() {
		let somethingInScope = true

		let somethingDeeperInScope = true

		print("prepare stuff")
		print(somethingInScope)

		print("fake the service")

		print(somethingDeeperInScope)

		print("Stuff right before each test")

		print("MOOAR stuff right before this test")

		print("LAST stuff right before this test")

		// Convert to `#expect`: expect("").to(beEmpty())

		print("clean up the things")

		print("clean foo")
	}
}
