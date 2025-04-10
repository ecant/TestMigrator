import SwiftSyntax
import SwiftSyntaxBuilder

final class XCTestImportRewriter: SyntaxRewriter {
    override func visit(_ node: ImportDeclSyntax) -> DeclSyntax {
        guard node.isQuickImportDeclaration else { return DeclSyntax(node) }
        return try! DeclSyntax(ImportDeclSyntax("import XCTest"))
    }
}
