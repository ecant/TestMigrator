import SwiftSyntax

enum QuickClassParser {
	static func parseClass(from classDecl: ClassDeclSyntax) -> ParsedQuickClass {
		let className = classDecl.name.text

        let otherMembers = classDecl.otherItemsInQuickSpecSubclass
        
        guard let specFunction = classDecl.specFunctionContents else {
            let spec = ParsedQuickSpecFunction(otherItems: nil,
                                               beforeEachBlocks: [],
                                               afterEachBlocks: [],
                                               tests: [])
            return ParsedQuickClass(className: className, spec: spec, otherMembers: otherMembers)
        }

		let testVisitor = TestVisitor(viewMode: .sourceAccurate)
		testVisitor.walk(specFunction)

		let spec = ParsedQuickSpecFunction(
			otherItems: specFunction.otherItems,
			beforeEachBlocks: specFunction.beforeEachBlocks,
			afterEachBlocks: specFunction.afterEachBlocks,
			tests: testVisitor.parsedTests)
        return ParsedQuickClass(className: className, spec: spec, otherMembers: otherMembers)
	}

	private final class TestVisitor: SyntaxVisitor {
		var parsedTests: [ParsedQuickTest] = []

		override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
			guard node.isItBlock else { return .visitChildren }

			guard let description = node.blockDescription,
				let itBlockContents = node.trailingClosure?.statements
			else {
				return .skipChildren
			}

			let initialTest = ParsedQuickTest(
				itBlock: itBlockContents,
				descriptions: [description],
				describeBlocks: [])

			let result = Self.parseTestAndAncestors(node: node, result: initialTest)
			parsedTests.append(result)

			return .skipChildren
		}

		/// Recursive function. Traverses the syntax tree starting from the test (i.e. "it" block), finding all the ancestor nodes until the top of the spec is reached.
		private static func parseTestAndAncestors(node: SyntaxProtocol, result: ParsedQuickTest) -> ParsedQuickTest {
			guard let parent = node.parent else {
                /// Exit condition for recursion
				return result
			}

            if let parentAsClass = parent.as(ClassDeclSyntax.self), let specFunction = parentAsClass.specFunctionContents {
                /// `justBeforeEach` blocks at the top level of the spec are treated differently than other top-level blocks.
                /// These need to be included with the ParsedQuickTest instead of on the ParsedQuickClass
                let describeBlock = ParsedQuickDescribeBlock(beforeEachBlocks: [], justBeforeEachBlocks: specFunction.justBeforeEachBlocks, afterEachBlocks: [], otherItems: [])
                let newResult = result.appending(describeBlock: describeBlock)
                return newResult
            }
            
			/// If this node is not a relevant block, continue to next ancestor.
			guard let parentAsFunctionCall = parent.as(FunctionCallExprSyntax.self),
				parentAsFunctionCall.isDescribeOrContextBlock
			else {
				return parseTestAndAncestors(node: parent, result: result)
			}

			let statements = parentAsFunctionCall.trailingClosure?.statements ?? []

			let newResult = result.appending(
				description: parentAsFunctionCall.blockDescription!,
				describeBlock: Self.parseDescribeBlock(statements: statements))

			return parseTestAndAncestors(node: parent, result: newResult)
		}

		private static func parseDescribeBlock(statements: CodeBlockItemListSyntax)
			-> ParsedQuickDescribeBlock
		{
			let beforeEachBlocks = statements.closures { $0.isBeforeEachBlock }
            let justBeforeEachBlocks = statements.closures { $0.isJustBeforeEachBlock }
            let afterEachBlocks = statements.closures { $0.isAfterEachBlock }
            
			let otherItems = statements
				.filter { codeBlockItem in
					guard let funcExpr = codeBlockItem.item.as(FunctionCallExprSyntax.self) else {
						return true
					}
                    return funcExpr.isOtherBlock
				}
            
			return ParsedQuickDescribeBlock(
				beforeEachBlocks: beforeEachBlocks,
                justBeforeEachBlocks: justBeforeEachBlocks,
				afterEachBlocks: afterEachBlocks,
				otherItems: otherItems)
		}
	}
}
