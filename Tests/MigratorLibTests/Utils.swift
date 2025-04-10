import Foundation
import FormatterLib
import XCTest

@testable import MigratorLib
func contents(_ fileName: String) -> String {
    let file = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent(fileName, isDirectory: false)
    return try! String.init(contentsOf: file, encoding: .utf8)
}

extension String {
    var trimmed: String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
}

enum MigrationMode {
    case swifttesting
    case xctest
}

func migrateAndAssertEqual(_ input: String, _ expectedOutput: String, mode: MigrationMode, file: StaticString = #filePath, line: UInt = #line) throws {
    let actualOutput: String
    if mode == .swifttesting {
        actualOutput = try Formatter.format(source: Migrator.migrateToSwiftTesting(input))
    } else {
        actualOutput = try Formatter.format(source: Migrator.migrateToXCTest(input))
    }
    XCTAssertEqual(expectedOutput.trimmed, actualOutput.trimmed, file: file, line: line)
}
