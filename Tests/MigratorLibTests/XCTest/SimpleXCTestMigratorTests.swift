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
}
