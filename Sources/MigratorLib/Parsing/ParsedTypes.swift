import SwiftSyntax

struct ParsedQuickClass {
    let className: String
    let spec: ParsedQuickSpecFunction?
    let otherMembers: MemberBlockItemListSyntax
}

struct ParsedQuickSpecFunction {
    let otherItems: CodeBlockItemListSyntax?
    let beforeEachBlocks: [CodeBlockItemListSyntax]
    let afterEachBlocks: [CodeBlockItemListSyntax]
    let tests: [ParsedQuickTest]
}

struct ParsedQuickDescribeBlock {
    let beforeEachBlocks: [CodeBlockItemListSyntax]
    let justBeforeEachBlocks: [CodeBlockItemListSyntax]
    let afterEachBlocks: [CodeBlockItemListSyntax]
    let otherItems: CodeBlockItemListSyntax
}

struct ParsedQuickTest {
    private let descriptions: [String]
    private let itBlock: CodeBlockItemListSyntax
    private let describeBlocks: [ParsedQuickDescribeBlock]

    var name: String {
        descriptions
            .reversed()
            .map { $0.toCamelCase() }
            .map { $0.removingNonAlphanumerics() }
            .joined(separator: "_")
    }

    var blocks: [CodeBlockItemListSyntax] {
        let otherItems = describeBlocks.reversed().map { $0.otherItems }

        /// The blocks were generated by first finding an "it" block and then traversing each parent node until reaching the top of the spec.
        /// So here we want to reverse the beforeEach blocks so they're in the order they should be executed in a text.
        let beforeEachBlocks = describeBlocks.reversed().flatMap { $0.beforeEachBlocks }

        let justBeforeEachBlocks = describeBlocks.reversed().flatMap { $0.justBeforeEachBlocks }

        /// The closest after each blocks to the "it" block should be run first, so these are in the correct order already
        let afterEachBlocks = describeBlocks.flatMap { $0.afterEachBlocks }

        return otherItems + beforeEachBlocks + justBeforeEachBlocks + [itBlock] + afterEachBlocks
    }

    init(itBlock: CodeBlockItemListSyntax, descriptions: [String], describeBlocks: [ParsedQuickDescribeBlock]) {
        self.itBlock = itBlock
        self.descriptions = descriptions
        self.describeBlocks = describeBlocks
    }

    func appending(description: String, describeBlock: ParsedQuickDescribeBlock) -> Self {
        ParsedQuickTest(
            itBlock: self.itBlock,
            descriptions: self.descriptions + [description],
            describeBlocks: self.describeBlocks + [describeBlock]
        )
    }

    func appending(describeBlock: ParsedQuickDescribeBlock) -> Self {
        ParsedQuickTest(
            itBlock: self.itBlock,
            descriptions: self.descriptions,
            describeBlocks: self.describeBlocks + [describeBlock]
        )
    }
}
