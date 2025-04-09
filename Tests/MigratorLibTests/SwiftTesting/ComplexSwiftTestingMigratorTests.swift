import FormatterLib
import XCTest

@testable import MigratorLib

/// Tests using real Quick spec files as input and real XCTest files as output.
final class ComplexSwiftTestingMigratorTests: XCTestCase {
    override class func setUp() {
        do {
            try Formatter.formatExampleTestsFilesInPackage()
        } catch {
            XCTFail("ERROR: \(error)")
        }
    }

    func testBasicExampleFile() throws {
        let input = contents("ExampleSpecs/BasicExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/BasicExampleTests.swift")
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }

    func testBeforeAndAfterExampleFile() throws {
        let input = contents("ExampleSpecs/BeforeAndAfterExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/BeforeAndAfterExampleTests.swift")
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }

    func testMultipleClassesExampleFile() throws {
        let input = contents("ExampleSpecs/MultipleClassesExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/MultipleClassesExampleTests.swift")
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }

    func testNestedExampleFile() throws {
        let input = contents("ExampleSpecs/NestedExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/NestedExampleTests.swift")
        let actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
        XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed)
    }
}
