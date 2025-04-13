import SwiftParser
import SwiftSyntax

/// Resources:
/// - Swift AST Explorer: https://swift-ast-explorer.com/
/// - SwiftSyntax documentation: https://github.com/swiftlang/swift-syntax/tree/601.0.1
public enum Migrator {

    /// Migrates the provided QuickSpec source code to XCTest format.
    ///
    /// - Parameter source: The original QuickSpec source code.
    /// - Returns: Migrated source code in XCTest format.
    public static func migrateToXCTest(_ source: String) -> String {
        let tree = Parser.parse(source: source)
            .transform { XCTestImportRewriter().visit($0) }
            .transform { XCTestClassRewriter().visit($0) }
        return tree.formatted().description
    }

    /// Migrates the provided QuickSpec source code to Swift Testing format.
    ///
    /// - Parameter source: The original QuickSpec source code.
    /// - Returns: Migrated source code in Swift Testing format.
    public static func migrateToSwiftTesting(_ source: String) -> String {
        let tree = Parser.parse(source: source)
            .transform { SwiftTestingImportRewriter().visit($0) }
            .transform { SwiftTestingClassRewriter().visit($0) }
        return tree.formatted().description
    }
}
