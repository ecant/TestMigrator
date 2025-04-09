import Foundation
import Testing

@Suite struct FirstClassExampleTests {
	@Test func test_doesTheThing() {
		// Convert to `#expect`: expect(true).to(beTrue())
		// Convert to `#expect`: expect(false).to(beFalse())
	}
}

struct FakeService {
	func makeItSo() {

	}
}

enum SomeNamespace {

	@Suite struct SecondClassExampleTests {
		let somethingWasHere = true

		@Test func test_doesTheThingAlso() {
			FakeService().makeItSo()
			// Convert to `#expect`: expect("").to(beEmpty())
		}
	}

	@Suite struct ThirdClassExampleTests {
		let somethingWasDefinitelyHere = true

	}
}
