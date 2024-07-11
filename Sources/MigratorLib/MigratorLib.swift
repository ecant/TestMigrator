import SwiftParser
import SwiftSyntax

/// https://swift-ast-explorer.com/
/// https://github.com/apple/swift-syntax/tree/508.0.1

public enum Migrator {
    public static func migrate(_ source: String) -> String {
        let tree = Parser.parse(source: source)
            .transform { QuickImportRewriter().visit($0) }
            .transform { QuickClassRewriter().visit($0) }
        return tree.formatted().description
    }
}
