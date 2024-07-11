import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

final class QuickClassRewriter: SyntaxRewriter {
    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard node.isQuickSpecSubclass else { return node.as(DeclSyntax.self)! }
        let parsedClass = QuickClassParser.parseClass(from: node)
        let newClassDecl = Self.generateClassDeclaration(from: parsedClass)
        return newClassDecl.as(DeclSyntax.self)!
    }
    
    private static func generateClassDeclaration(from parsedClass: ParsedQuickClass) -> ClassDeclSyntax {
        let className = parsedClass.className.replacingOccurrences(of: "Spec", with: "Tests")
                
        let setUpAndTearDown = [
            Self.generateSetUpFunctionDeclaration(from: parsedClass)?.with(\.trailingTrivia, .newline),
            Self.generateTearDownFunctionDeclaration(from: parsedClass)?.with(\.trailingTrivia, .newline)
        ]
        
        let testDeclarations = parsedClass.tests
            .map { Self.generateTestFunctionDeclaration(from: $0) }
            .mapSkippingLast { $0.with(\.trailingTrivia, .newline) }
        
        let functionDeclarations = (setUpAndTearDown + testDeclarations)
            .compactMap { $0 }
            .map { $0.description }
       
        let statements = ([Self.generateOtherItems(from: parsedClass)] + functionDeclarations)
            .compactMap { $0 }
            .mapSkippingLast { $0 + "\n" }
            .joined()
        
        return try! ClassDeclSyntax(
            """
            final class \(raw: className): XCTestCase {
                \(raw: statements)
            }
            """
        )
        .with(\.leadingTrivia, .newlines(2))
    }
    
    private static func generateOtherItems(from parsedClass: ParsedQuickClass) -> String? {
        guard let otherItems = parsedClass.otherItems, otherItems.description.isNotEmpty else { return nil }
        return [otherItems].formattedString() + "\n"
    }
    
    private static func generateSetUpFunctionDeclaration(from parsedClass: ParsedQuickClass) -> FunctionDeclSyntax? {
        guard parsedClass.beforeEachBlocks.isNotEmpty else { return nil }
                        
        return try! FunctionDeclSyntax(
            """
            override func setUp() {
                super.setUp()
            
                \(raw: parsedClass.beforeEachBlocks.formattedString())
            }
            """)
    }
    
    private static func generateTearDownFunctionDeclaration(from parsedClass: ParsedQuickClass) -> FunctionDeclSyntax? {
        guard parsedClass.afterEachBlocks.isNotEmpty else { return nil }
                        
        return try! FunctionDeclSyntax(
            """
            override func tearDown() {
                super.tearDown()
            
                \(raw: parsedClass.afterEachBlocks.formattedString())
            }
            """)
    }
    
    private static func generateTestFunctionDeclaration(from parsedTest: ParsedQuickTest) -> FunctionDeclSyntax {
        let name = parsedTest.descriptions
            .reversed()
            .map { description in
                description
                    .capitalized
                    .split(separator: " ")
                    .filter { !$0.isEmpty }
                    .joined(separator: "")
            }
            .joined(separator: "_")
                
        return try! FunctionDeclSyntax(
            """
            func test_\(raw: name)() {
                \(raw: parsedTest.blocks.formattedString())
            }
            """)
    }
}
