import FormatterLib
import XCTest

@testable import MigratorLib

/// Tests using real Quick spec files as input and real XCTest files as output.
final class ComplexSwiftTestingMigratorTests: XCTestCase {
    override class func setUp() {
        do {
            /// Format the input test files with swift-format before running tests. We also format the generated output in each test.
            /// This avoids false negatives in test comparisons due exclusively to formatting differences.
            try Formatter.formatExampleTestsFilesInPackage()
        } catch {
            XCTFail("ERROR: \(error)")
        }
    }

    func testBasicExampleFile() throws {
        let input = contents("ExampleSpecs/BasicExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/BasicExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testBeforeAndAfterExampleFile() throws {
        let input = contents("ExampleSpecs/BeforeAndAfterExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/BeforeAndAfterExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testMultipleClassesExampleFile() throws {
        let input = contents("ExampleSpecs/MultipleClassesExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/MultipleClassesExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }

    func testNestedExampleFile() throws {
        let input = contents("ExampleSpecs/NestedExampleSpec.swift")
        let expectedOutput = contents("ExampleTests/NestedExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .swifttesting)
    }
}
