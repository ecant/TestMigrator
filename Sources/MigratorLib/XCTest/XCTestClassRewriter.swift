import Foundation
import SwiftSyntax
import SwiftSyntaxBuilder

final class XCTestClassRewriter: SyntaxRewriter {
	override func visit(_ node: ClassDeclSyntax) -> DeclSyntax {
		guard node.isQuickSpecSubclass else { return DeclSyntax(node) }
		let parsedClass = QuickClassParser.parseClass(from: node)
		let newClassDecl = Self.generateClassDeclaration(from: parsedClass)
		return DeclSyntax(newClassDecl)
	}

	private static func generateClassDeclaration(from parsedClass: ParsedQuickClass)
		-> DeclSyntax
	{
		let className = parsedClass.className.replacingOccurrences(of: "Spec", with: "Tests")
        let otherClassMembers = parsedClass.otherMembers.isEmpty ? nil : parsedClass.otherMembers.with(\.leadingTrivia, []).with(\.trailingTrivia, .newline).description
        
        guard let parsedSpec = parsedClass.spec else {
            return DeclSyntax(
                """
                final class \(raw: className): XCTestCase {
                    \(raw: otherClassMembers)
                }
                """
            )
            .with(\.leadingTrivia, .newlines(2))
        }
        
        let otherItems = Self.generateOtherItems(from: parsedSpec)?.description
        let setUp = Self.generateSetUpFunctionDeclaration(from: parsedSpec)?.with(\.trailingTrivia, .newline).description
        let tearDown = Self.generateTearDownFunctionDeclaration(from: parsedSpec)?.with(\.trailingTrivia, .newline).description

		let testDeclarations = parsedSpec.tests
			.map { Self.generateTestFunctionDeclaration(from: $0) }
			.mapSkippingLast { $0.with(\.trailingTrivia, .newline) }
            .map { $0.description }
            .filter { $0.isNotEmpty }

        let statements = ([otherClassMembers, otherItems, setUp, tearDown].compacted() + testDeclarations)
            .mapSkippingLast { $0 + "\n" }
            .joined()

		return DeclSyntax(
			"""
			final class \(raw: className): XCTestCase {
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

	private static func generateSetUpFunctionDeclaration(from parsedSpec: ParsedQuickSpecFunction) -> FunctionDeclSyntax? {
		guard parsedSpec.beforeEachBlocks.isNotEmpty else { return nil }

		return try! FunctionDeclSyntax(
			"""
			override func setUp() {
			    super.setUp()

			    \(raw: parsedSpec.beforeEachBlocks.formattedString())
			}
			""")
	}

	private static func generateTearDownFunctionDeclaration(from parsedSpec: ParsedQuickSpecFunction) -> FunctionDeclSyntax? {
		guard parsedSpec.afterEachBlocks.isNotEmpty else { return nil }

		return try! FunctionDeclSyntax(
			"""
			override func tearDown() {
			    super.tearDown()

			    \(raw: parsedSpec.afterEachBlocks.formattedString())
			}
			""")
	}

	private static func generateTestFunctionDeclaration(from parsedTest: ParsedQuickTest) -> FunctionDeclSyntax {
		try! FunctionDeclSyntax(
			"""
			func test_\(raw: parsedTest.name)() async throws {
			    \(raw: parsedTest.blocks.formattedString())
			}
			""")
	}
}
