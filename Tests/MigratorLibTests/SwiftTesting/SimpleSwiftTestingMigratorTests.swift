import FormatterLib
import XCTest

@testable import MigratorLib

final class SimpleSwiftTestingMigratorTests: XCTestCase {
    func testQuickImportRenamed() throws {
        let input = "import Quick"
        let expectedOutput = "import Testing"
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }
    
    func testNimbleImportDeleted() throws {
        let input = "import Nimble"
        let expectedOutput = ""
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }

    func testNoSpecFunction_stillMigratesAndAddsNewlines() throws {
        let input = "class ExampleSpec: QuickSpec {}"
        let expectedOutput = "@Suite struct ExampleTests {\n\n}"
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }

    func testNoSpecFunction_preservesNewlines() throws {
        let input = "final class ExampleSpec: QuickSpec {\n\n}"
        let expectedOutput = "@Suite struct ExampleTests {\n\n}"
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }
}
