import Foundation
import Testing

@Suite struct FirstClassExampleTests {
    @Test func doesTheThing() async throws {
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

        @Test func doesTheThingAlso() async throws {
            FakeService().makeItSo()
            // Convert to `#expect`: expect("").to(beEmpty())
        }
    }

    @Suite struct ThirdClassExampleTests {
        let somethingWasDefinitelyHere = true

    }
}
