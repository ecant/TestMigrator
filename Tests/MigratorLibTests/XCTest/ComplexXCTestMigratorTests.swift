import FormatterLib
import XCTest

@testable import MigratorLib

/// Tests using real Quick spec files as input and real XCTest files as output.
final class ComplexXCTestMigratorTests: XCTestCase {
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
        let expectedOutput = contents("ExampleXCTests/BasicExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testBeforeAndAfterExampleFile() throws {
        let input = contents("ExampleSpecs/BeforeAndAfterExampleSpec.swift")
        let expectedOutput = contents("ExampleXCTests/BeforeAndAfterExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testMultipleClassesExampleFile() throws {
        let input = contents("ExampleSpecs/MultipleClassesExampleSpec.swift")
        let expectedOutput = contents("ExampleXCTests/MultipleClassesExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }

    func testNestedExampleFile() throws {
        let input = contents("ExampleSpecs/NestedExampleSpec.swift")
        let expectedOutput = contents("ExampleXCTests/NestedExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }
    
    func testBehaviorExampleFile() throws {
        let input = contents("ExampleSpecs/BehaviorExampleSpec.swift")
        let expectedOutput = contents("ExampleXCTests/BehaviorExampleTests.swift")
        try migrateAndAssertEqual(input, expectedOutput, mode: .xctest)
    }
}
