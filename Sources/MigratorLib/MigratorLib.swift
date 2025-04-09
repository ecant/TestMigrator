import SwiftParser
import SwiftSyntax

/// https://swift-ast-explorer.com/
/// https://github.com/swiftlang/swift-syntax/tree/601.0.1

public enum Migrator {
    public static func migrateToXCTest(_ source: String) -> String {
        let tree = Parser.parse(source: source)
            .transform { XCTestImportRewriter().visit($0) }
            .transform { XCTestClassRewriter().visit($0) }
        return tree.formatted().description
    }
    
    public static func migrateToSwiftTesting(_ source: String) -> String {
        let tree = Parser.parse(source: source)
            .transform { SwiftTestingImportRewriter().visit($0) }
            .transform { SwiftTestingClassRewriter().visit($0) }
        let content = tree.formatted().description
        
        // Comment out Nimble `expect` calls for now.
        let expectPattern = try! Regex(#"expect\("#)
        return content.replacing(expectPattern, with: "// Convert to `#expect`: expect(")
    }
}
