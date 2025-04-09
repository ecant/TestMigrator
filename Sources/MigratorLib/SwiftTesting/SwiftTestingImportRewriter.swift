import SwiftSyntax
import SwiftSyntaxBuilder

final class SwiftTestingImportRewriter: SyntaxRewriter {
    override func visit(_ node: ImportDeclSyntax) -> DeclSyntax {
        if node.isQuickImportDeclaration {
            return try! DeclSyntax(ImportDeclSyntax("import Testing"))
        }
        
        if node.isNimbleImportDeclaration {
            return DeclSyntax("")
        }
        
        return DeclSyntax(node)
    }
}
