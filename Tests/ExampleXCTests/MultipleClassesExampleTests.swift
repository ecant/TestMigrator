import Foundation
import Nimble
import XCTest

final class FirstClassExampleTests: XCTestCase {
	func test_doesTheThing() {
		expect(true).to(beTrue())
		expect(false).to(beFalse())
	}
}

struct FakeService {
	func makeItSo() {

	}
}

enum SomeNamespace {

	final class SecondClassExampleTests: XCTestCase {
		let somethingWasHere = true

		func test_doesTheThingAlso() {
			FakeService().makeItSo()
			expect("").to(beEmpty())
		}
	}

	final class ThirdClassExampleTests: XCTestCase {
		let somethingWasDefinitelyHere = true

	}
}
