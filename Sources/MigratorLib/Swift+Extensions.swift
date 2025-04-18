extension Collection {
    /// Map over a collection invoking the transform function on each element except the last element.
    /// The last element is returned unchanged.
    /// The result of the transform must be the same type as the original element.
    func mapSkippingLast(_ transform: (Element) -> Element) -> [Element] {
        var newValues: [Element] = []
        for (offset, element) in self.enumerated() {
            if offset < self.count - 1 {
                newValues.append(transform(element))
            } else {
                newValues.append(element)
            }
        }
        return newValues
    }
}

extension Collection {
    var isNotEmpty: Bool {
        !self.isEmpty
    }

    func compacted<T>() -> [T] where Element == T? {
        compactMap { $0 }
    }
}

extension String {
    func toCamelCase() -> String {
        // If the string doesn't contain spaces, assume it's already in camelCase or a single word — return as-is
        guard self.contains(" ") else { return self }
        
        let components = self.split(separator: " ").filter { !$0.isEmpty }

        guard let first = components.first?.lowercased() else {
            return ""
        }

        let rest = components.dropFirst().map { $0.capitalized }
        return ([first] + rest).joined()
    }

    func removingNonAlphanumerics() -> String {
        self.components(separatedBy: .alphanumerics.inverted).joined()
    }
}
