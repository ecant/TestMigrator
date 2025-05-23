import FormatterLib
import XCTest

@testable import MigratorLib

final class SimpleXCTestMigratorTests: XCTestCase {
    func testQuickImportRenamed() throws {
        let input = "import Quick"
        let expectedOutput = "import XCTest"
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testNimbleImportLeftAlone() throws {
        let input = "import Nimble"
        let expectedOutput = input
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testNoSpecFunction_stillConvertsToXCTestAndAddsNewlines() throws {
        let input = "class ExampleSpec: QuickSpec {}"
        let expectedOutput = "final class ExampleTests: XCTestCase {\n\n}"
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testNoQuickSpec_leavesContentAlone() throws {
        let input = "class SomeClass: SomeSuperClass {\n}"
        let expectedOutput = input
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testNoSpecFunction_preservesNewlines() throws {
        let input = "class ExampleSpec: QuickSpec {\n\n}"
        let expectedOutput = "final class ExampleTests: XCTestCase {\n\n}"
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testEmptySpecFunctionReturnsNoTests() throws {
        let input = "class ExampleSpec: QuickSpec { override class func spec() {} }"
        let expectedOutput = "final class ExampleTests: XCTestCase {\n\n}"
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testSimpleFunctionConverted() throws {
        let input = """
            class ExampleSpec: QuickSpec { 
                override class func spec() {  
                    it("does the thing") {}
                } 
            }
            """
        let expectedOutput = """
            final class ExampleTests: XCTestCase {
                func test_doesTheThing() async throws {

                }
            }
            """
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testRemovesNonAlphaNumericsFromTestName() throws {
        let input = """
            class ExampleSpec: QuickSpec { 
                override class func spec() {  
                    it("calls the client_service()") {}
                } 
            }
            """
        let expectedOutput = """
            final class ExampleTests: XCTestCase {
                func test_callsTheClientService() async throws {

                }
            }
            """
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }
}
