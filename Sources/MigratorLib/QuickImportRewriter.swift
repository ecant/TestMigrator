import SwiftSyntax
import SwiftSyntaxBuilder

final class QuickImportRewriter: SyntaxRewriter {
    override func visit(_ node: ImportDeclSyntax) -> DeclSyntax {
        guard node.isQuickImportDeclaration else { return node.as(DeclSyntax.self)! }
        return try! ImportDeclSyntax("import XCTest").as(DeclSyntax.self)!
    }
}
