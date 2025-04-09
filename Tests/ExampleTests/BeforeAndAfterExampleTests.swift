import Foundation
import Testing

@Suite struct BeforeAndAfterExampleTests {
	var something: String!
	let helloWorld = true

	init() {
		something = ""
		print(something ?? "")

		print("another top-level setup")
	}

	@Test func test_doesTheStuff() {
		print("top-level justBeforeEach")

		print(helloWorld)
		// Convert to `#expect`: expect(true).to(beTrue())
		// Convert to `#expect`: expect(false).to(beFalse())

		print("top-level teardown")

		print("another top-level teardown")
	}
}
