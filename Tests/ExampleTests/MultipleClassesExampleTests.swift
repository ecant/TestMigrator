import Foundation
import XCTest
import Nimble

final class FirstClassExampleTests: XCTestCase {
    func test_DoesTheThing() {
        expect(true).to(beTrue())
        expect(false).to(beFalse())
    }
}

struct FakeService {
    func makeItSo() {}
}

enum SomeNamespace {
    
    final class SecondClassExampleTests: XCTestCase {
        func test_DoesTheThingAlso() {
            FakeService().makeItSo()
            expect("").to(beEmpty())
        }
    }
    
    final class ThirdClassExampleTests: XCTestCase {
        
    }
}
