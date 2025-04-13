import SwiftSyntax

extension SourceFileSyntax {
    func transform(_ transform: (Self) -> Self) -> Self {
        transform(self)
    }
}

extension ClassDeclSyntax {
    var specFunctionContents: FunctionDeclSyntax? {
        self.memberBlock.members.compactMap {
            $0.decl.as(FunctionDeclSyntax.self)
        }.first { $0.isClassSpecFunction }
    }

    var otherItemsInQuickSpecSubclass: MemberBlockItemListSyntax {
        self.memberBlock.members.filter {
            if let functionDecl = $0.decl.as(FunctionDeclSyntax.self), functionDecl.isClassSpecFunction {
                return false
            }
            return true
        }
    }

    var isQuickSpecSubclass: Bool {
        guard let inheritanceTokens = self.inheritanceClause?.tokens(viewMode: .sourceAccurate) else {
            return false
        }
        return inheritanceTokens.map { $0.text }.contains { $0 == "QuickSpec" }
    }
}

extension ImportDeclSyntax {
    var isQuickImportDeclaration: Bool {
        self.path.first?.name.text == "Quick"
    }

    var isNimbleImportDeclaration: Bool {
        self.path.first?.name.text == "Nimble"
    }
}

extension FunctionDeclSyntax {
    var isClassSpecFunction: Bool {
        let mods = self.modifiers.map { $0.name.text }
        return self.name.text == "spec" && mods == ["override", "class"]
    }

    var beforeEachBlocks: [CodeBlockItemListSyntax] {
        body?.statements.closures { $0.isBeforeEachBlock } ?? []
    }

    var justBeforeEachBlocks: [CodeBlockItemListSyntax] {
        body?.statements.closures { $0.isJustBeforeEachBlock } ?? []
    }

    var afterEachBlocks: [CodeBlockItemListSyntax] {
        body?.statements.closures { $0.isAfterEachBlock } ?? []
    }

    var otherItems: CodeBlockItemListSyntax? {
        guard let body else { return nil }

        let otherItems = body.statements
            .filter { codeBlockItem in
                guard let funcExpr = codeBlockItem.item.as(FunctionCallExprSyntax.self) else { return true }
                return funcExpr.isOtherBlock
            }

        return CodeBlockItemListSyntax(otherItems)
    }
}

extension FunctionCallExprSyntax {
    var isOtherBlock: Bool {
        !isKnownBlock
    }

    var isKnownBlock: Bool {
        self.isBeforeEachBlock || self.isAfterEachBlock || self.isItBlock || self.isItBehavesLikeBlock || self.isDescribeOrContextBlock || self.isJustBeforeEachBlock
    }

    var isItBlock: Bool { isBlock(matchingIdentifier: "it") }
    
    var isItBehavesLikeBlock: Bool { isBlock(matchingIdentifier: "itBehavesLike") }

    var isDescribeOrContextBlock: Bool {
        isBlock(matchingIdentifier: "describe") || isBlock(matchingIdentifier: "context")
    }

    var isBeforeEachBlock: Bool { isBlock(matchingIdentifier: "beforeEach") }

    var isJustBeforeEachBlock: Bool { isBlock(matchingIdentifier: "justBeforeEach") }

    var isAfterEachBlock: Bool { isBlock(matchingIdentifier: "afterEach") }

    var blockDescription: String? {
        guard let stringLiteral = arguments.first?.expression.as(StringLiteralExprSyntax.self) else {
            return nil
        }
        return stringLiteral.segments.firstToken(viewMode: .sourceAccurate)?.text
    }

    private func isBlock(matchingIdentifier identifier: String) -> Bool {
        if let identifierExpr = calledExpression.as(DeclReferenceExprSyntax.self),
            identifierExpr.baseName.text == identifier
        {
            return true
        }
        return false
    }
}

extension CodeBlockItemListSyntax {
    func closures(matching predicate: (FunctionCallExprSyntax) -> Bool) -> [CodeBlockItemListSyntax] {
        self.compactMap { codeBlockItem -> CodeBlockItemListSyntax? in
            guard let funcExpr = codeBlockItem.item.as(FunctionCallExprSyntax.self) else {
                return nil
            }
            return predicate(funcExpr) ? funcExpr.trailingClosure?.statements : nil
        }
    }
}

extension Array where Element == CodeBlockItemSyntax {
    func withTrailingTrivia(_ trailingTrivia: Trivia) -> Self {
        var new = self
        if let last = new.popLast() {
            new.append(last.with(\.trailingTrivia, trailingTrivia))
        }
        return new
    }
}

extension CodeBlockItemSyntax {
    func withoutTrivia() -> Self {
        self.with(\.leadingTrivia, [])
            .with(\.trailingTrivia, [])
    }
}

extension Array where Element == CodeBlockItemListSyntax {
    func formattedString() -> String {
        self.map { blockItemList in
            blockItemList.map { $0.withoutTrivia().with(\.leadingTrivia, .tabs(1)) }
        }
        /// We want a newline in between the code extracted from each different block but we don't want to add
        /// one after the last block
        .mapSkippingLast { blockItems in
            blockItems.withTrailingTrivia(.newline)
        }
        .map { blockItems in
            blockItems.map { $0.description }
        }
        .flatMap { $0 }
        .joined(separator: "\n")
    }
}
