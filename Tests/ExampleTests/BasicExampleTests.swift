import Foundation
import Testing

@Suite struct BasicExampleTests {
    @Test func whenFooBecomesBar_doesTheStuff() async throws {
        print("prepare stuff")
        print("prepare more stuff")

        expect(true).to(beTrue())
        expect(false).to(beFalse())
    }
}
