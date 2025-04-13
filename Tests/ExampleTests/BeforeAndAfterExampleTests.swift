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

    @Test func doesTheStuff() async throws {
        print("top-level justBeforeEach")

        print(helloWorld)
        expect(true).to(beTrue())
        expect(false).to(beFalse())

        print("top-level teardown")

        print("another top-level teardown")
    }
}
