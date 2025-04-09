import Foundation
import Nimble
import Quick

final class FirstClassExampleSpec: QuickSpec {
	override class func spec() {
		it("does the thing") {
			expect(true).to(beTrue())
			expect(false).to(beFalse())
		}
	}
}

struct FakeService {
	func makeItSo() {

	}
}

enum SomeNamespace {
	final class SecondClassExampleSpec: QuickSpec {
		let somethingWasHere = true

		override class func spec() {
			it("does the thing also") {
				FakeService().makeItSo()
				expect("").to(beEmpty())
			}
		}
	}
	final class ThirdClassExampleSpec: QuickSpec {
		let somethingWasDefinitelyHere = true
	}
}
