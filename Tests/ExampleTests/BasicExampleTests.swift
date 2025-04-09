import Foundation
import Testing

@Suite struct BasicExampleTests {
	@Test func test_whenFooBecomesBar_doesTheStuff() {
		print("prepare stuff")
		print("prepare more stuff")

		// Convert to `#expect`: expect(true).to(beTrue())
		// Convert to `#expect`: expect(false).to(beFalse())
	}
}
