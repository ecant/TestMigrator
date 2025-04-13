import Foundation
import Testing

@Suite struct FirstClassExampleTests {
    @Test func doesTheThing() async throws {
        expect(true).to(beTrue())
        expect(false).to(beFalse())
    }
}

struct FakeService {
    func makeItSo() {

    }
}

enum SomeNamespace {

    @Suite struct SecondClassExampleTests {
        let somethingWasHere = true

        @Test func doesTheThingAlso() async throws {
            FakeService().makeItSo()
            expect("").to(beEmpty())
        }
    }

    @Suite struct ThirdClassExampleTests {
        let somethingWasDefinitelyHere = true

    }
}
