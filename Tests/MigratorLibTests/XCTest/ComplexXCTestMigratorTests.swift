import FormatterLib
import XCTest

@testable import MigratorLib

/// Tests using real Quick spec files as input and real XCTest files as output.
final class ComplexXCTestMigratorTests: XCTestCase {
	override class func setUp() {
		do {
			try Formatter.formatExampleTestsFilesInPackage()
		} catch {
			XCTFail("ERROR: \(error)")
		}
	}

	func testBasicExampleFile() throws {
		let input = contents("ExampleSpecs/BasicExampleSpec.swift")
		let expectedOutput = contents("ExampleXCTests/BasicExampleTests.swift")
		let actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
		XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
	}

	func testBeforeAndAfterExampleFile() throws {
		let input = contents("ExampleSpecs/BeforeAndAfterExampleSpec.swift")
		let expectedOutput = contents("ExampleXCTests/BeforeAndAfterExampleTests.swift")
		let actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
		XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
	}

	func testMultipleClassesExampleFile() throws {
		let input = contents("ExampleSpecs/MultipleClassesExampleSpec.swift")
		let expectedOutput = contents("ExampleXCTests/MultipleClassesExampleTests.swift")
		let actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
		XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
	}

	func testNestedExampleFile() throws {
		let input = contents("ExampleSpecs/NestedExampleSpec.swift")
		let expectedOutput = contents("ExampleXCTests/NestedExampleTests.swift")
		let actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
		XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
	}
}
