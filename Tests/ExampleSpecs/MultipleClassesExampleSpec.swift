import Foundation
import Quick
import Nimble

final class FirstClassExampleSpec: QuickSpec {
    override class func spec() {
        it("does the thing") {
            expect(true).to(beTrue())
            expect(false).to(beFalse())
        }
    }
}

struct FakeService {
    func makeItSo() {}
}

enum SomeNamespace {
    final class SecondClassExampleSpec: QuickSpec {
        override class func spec() {
            it("does the thing also") {
                FakeService().makeItSo()
                expect("").to(beEmpty())
            }
        }
    }
    final class ThirdClassExampleSpec: QuickSpec {
        
    }
}
