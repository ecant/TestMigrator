import Foundation
import XCTest
import SwiftSyntax
import SwiftSyntaxBuilder
@testable import MigratorLib

final class MigratorLibTests: XCTestCase {
	
	/// Test with real Quick specs and XCTest tests as input and output, so we can have compiler support when writing the examples themselves.
	
	func testBasicExampleFile() throws {
		let input = contents("ExampleSpecs/BasicExampleSpec.swift")
		let expectedOutput = Self.formattedSource(contents("ExampleTests/BasicExampleTests.swift"))
		let output = Migrator.migrate(input)
		assertEqualOutput(output, expectedOutput)
		print(output)
	}
	
	func testBeforeAndAfterExampleFile() throws {
		let input = contents("ExampleSpecs/BeforeAndAfterExampleSpec.swift")
		let expectedOutput = Self.formattedSource(contents("ExampleTests/BeforeAndAfterExampleTests.swift"))
		let output = Migrator.migrate(input)
		assertEqualOutput(output, expectedOutput)
		print(output)
	}
	
	func testMultipleClassesExampleFile() throws {
		let input = contents("ExampleSpecs/MultipleClassesExampleSpec.swift")
		let expectedOutput = Self.formattedSource(contents("ExampleTests/MultipleClassesExampleTests.swift"))
		let output = Migrator.migrate(input)
		assertEqualOutput(output, expectedOutput)
		print(output)
	}
	
	func testNestedExampleFile() throws {
		let input = contents("ExampleSpecs/NestedExampleSpec.swift")
		let expectedOutput = Self.formattedSource(contents("ExampleTests/NestedExampleTests.swift"))
		let output = Migrator.migrate(input)
		assertEqualOutput(output, expectedOutput)
		print(output)
	}
	
	/// Other tests where we don't need a whole file example file
	
	func testQuickImportRenamed() {
		let input = "import Quick"
		let expectedOutput = Self.formattedSource("import XCTest")
		let output = Migrator.migrate(input)
		assertEqualOutput(output, expectedOutput)
		print(output)
	}
	
	func testNoSpecFunction_stillConvertsToXCTest() {
		let input = "class ExampleSpec: QuickSpec {}"
		let expectedOutput = Self.formattedSource("\n\nfinal class ExampleTests: XCTestCase {\n\n}")
		let output = Migrator.migrate(input)
		assertEqualOutput(output, expectedOutput)
		print(output)
	}
}

// MARK: - Helpers

extension MigratorLibTests {
	private static func formattedSource(_ stringLiteral: String) -> String {
		SourceFileSyntax(stringLiteral: stringLiteral).formatted().description
	}
	
	private func contents(_ fileName: String) -> String {
		let file = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
			.appendingPathComponent(fileName, isDirectory: false)
		return try! String.init(contentsOf: file)
	}
	
	private func assertEqualOutput(_ actual: String, _ expected: String, file: StaticString = #filePath, line: UInt = #line) {
		func failTest(_ errorMessage: String) {
			XCTFail("assertEqualOutput: \(errorMessage)", file: file, line: line)
		}
		
		let actualLines = actual.components(separatedBy: .newlines)
		let expectedLines = expected.components(separatedBy: .newlines)
		
		guard expectedLines.count == actualLines.count else {
			failTest("Line count not equal. \(actual.escaped) is not equal to \(expected.escaped)")
			return
		}
		
		for (index, (actualLine, expectedLine)) in zip(actualLines, expectedLines).enumerated() {
			if actualLine.trimmed != expectedLine.trimmed  {
				failTest("Line not equal.\nLine \(index):\n\(actualLine.escaped) is not equal to \(expectedLine.escaped).\nOverall:\n\(actual.escaped) is not equal to \(expected.escaped)")
				continue
			}
		}
	}
}

// MARK: - Extensions

private extension String {
	var escaped: String {
		"(\"\(self)\")"
	}
	
	var trimmed: String {
		self.trimmingCharacters(in: .whitespaces)
	}
}
