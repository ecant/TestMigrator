import FormatterLib
import XCTest

@testable import MigratorLib

final class SimpleXCTestMigratorTests: XCTestCase {
	func testQuickImportRenamed() throws {
		let input = "import Quick"
		let expectedOutput = "import XCTest"
		let actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
		XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
	}

	func testNoSpecFunction_stillConvertsToXCTestAndAddsNewlines() throws {
		let input = "class ExampleSpec: QuickSpec {}"
		let expectedOutput = "final class ExampleTests: XCTestCase {\n\n}"
		let actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
		XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
	}

	func testNoSpecFunction_preservesNewlines() throws {
		let input = "final class ExampleSpec: QuickSpec {\n\n}"
		let expectedOutput = "final class ExampleTests: XCTestCase {\n\n}"
		let actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
		XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
	}
}
