import FormatterLib
import XCTest

@testable import MigratorLib

final class SimpleSwiftTestingMigratorTests: XCTestCase {
    func testQuickImportRenamed() throws {
        let input = "import Quick"
        let expectedOutput = "import Testing"
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testNimbleImportDeleted() throws {
        let input = "import Nimble"
        let expectedOutput = ""
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testNoQuickSpec_leavesContentAlone() throws {
        let input = "class SomeClass: SomeSuperClass {\n}"
        let expectedOutput = input
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testNoSpecFunction_stillMigratesAndAddsNewlines() throws {
        let input = "class ExampleSpec: QuickSpec {}"
        let expectedOutput = "@Suite struct ExampleTests {\n\n}"
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testNoSpecFunction_preservesNewlines() throws {
        let input = "final class ExampleSpec: QuickSpec {\n\n}"
        let expectedOutput = "@Suite struct ExampleTests {\n\n}"
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testEmptySpecFunctionReturnsNoTests() throws {
        let input = "class ExampleSpec: QuickSpec { override class func spec() {} }"
        let expectedOutput = "@Suite struct ExampleTests {\n\n}"
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
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
            @Suite struct ExampleTests {
                @Test func doesTheThing() async throws {

                }
            }
            """
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
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
            @Suite struct ExampleTests {
                @Test func callsTheClientService() async throws {

                }
            }
            """
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }
}
