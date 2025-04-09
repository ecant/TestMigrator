import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

final class SwiftTestingClassRewriter: SyntaxRewriter {
    override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
        guard node.isQuickSpecSubclass else { return DeclSyntax(node) }
        let parsedClass = QuickClassParser.parseClass(from: node)
        return Self.generateDeclaration(from: parsedClass)
    }

    private static func generateDeclaration(from parsedClass: ParsedQuickClass) -> DeclSyntax {
        let className = parsedClass.className.replacingOccurrences(of: "Spec", with: "Tests")
        let otherClassMembers = parsedClass.otherMembers.isEmpty ? nil : parsedClass.otherMembers.with(\.leadingTrivia, []).with(\.trailingTrivia, .newline).description
        
        guard let parsedSpec = parsedClass.spec else {
            return DeclSyntax(
                """
                @Suite struct \(raw: className) {
                    \(raw: otherClassMembers)
                }
                """
            )
            .with(\.leadingTrivia, .newlines(2))
        }
        
        let otherSpecItems = Self.generateOtherItems(from: parsedSpec)?.description
        
        let initFunc = Self.generateInitFunctionDeclaration(from: parsedSpec)?.with(\.trailingTrivia, .newline).description
        
        let testDeclarations = parsedSpec.tests
            .map { Self.generateTestFunctionDeclaration(from: $0, parsedSpec: parsedSpec) }
            .mapSkippingLast { $0.with(\.trailingTrivia, .newline) }
            .map { $0.description }
            .filter { $0.isNotEmpty }
        
        let statements = ([otherClassMembers, otherSpecItems, initFunc].compacted() + testDeclarations)
            .mapSkippingLast { $0 + "\n" }
            .joined()

        return DeclSyntax(
            """
            @Suite struct \(raw: className) {
                \(raw: statements)
            }
            """
        )
        .with(\.leadingTrivia, .newlines(2))
    }

    private static func generateOtherItems(from parsedSpec: ParsedQuickSpecFunction) -> String? {
        guard let otherItems = parsedSpec.otherItems, otherItems.description.isNotEmpty else {
            return nil
        }
        return [otherItems].formattedString() + "\n"
    }

    private static func generateInitFunctionDeclaration(from parsedSpec: ParsedQuickSpecFunction) -> DeclSyntax? {
        guard parsedSpec.beforeEachBlocks.isNotEmpty else { return nil }

        return DeclSyntax(
            """
            init() {
                \(raw: parsedSpec.beforeEachBlocks.formattedString())
            }
            """)
    }

    private static func generateTestFunctionDeclaration(from parsedTest: ParsedQuickTest, parsedSpec: ParsedQuickSpecFunction) -> FunctionDeclSyntax {
        let blocks = (parsedTest.blocks + parsedSpec.afterEachBlocks).formattedString()
        return try! FunctionDeclSyntax(
            """
            @Test func test_\(raw: parsedTest.name)() {
                \(raw: blocks)
            }
            """)
    }
}
