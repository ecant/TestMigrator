import SwiftSyntax
import SwiftSyntaxBuilder

final class SwiftTestingImportRewriter: SyntaxRewriter {
//    override func visit(_ node: ImportDeclSyntax) -> DeclSyntax {
//        if node.isQuickImportDeclaration {
//            return try! DeclSyntax(ImportDeclSyntax("import Testing"))
//        }
//        
//        if node.isNimbleImportDeclaration {
//            return DeclSyntax("")
//        }
//        
//        return DeclSyntax(node)
//    }
//    
    override func visit(_ node: SourceFileSyntax) -> SourceFileSyntax {
        let newStatements = node.statements.compactMap { statement -> CodeBlockItemSyntax? in
            guard let decl = statement.item.as(DeclSyntax.self), let importDecl = decl.as(ImportDeclSyntax.self) else {
                return statement
            }
            
            if importDecl.isQuickImportDeclaration {
                let newImport = try! ImportDeclSyntax("import Testing")
                return CodeBlockItemSyntax(item: .decl(DeclSyntax(newImport)))
            }
            
            if importDecl.isNimbleImportDeclaration {
                return nil
            }
            
            return statement
        }
        
        return node.with(\.statements, CodeBlockItemListSyntax(newStatements))
    }
}
