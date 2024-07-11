extension Collection {
    /// Map over a collection invoking the transform function on each element except the last element.
    /// The last element is returned unchanged, and for this reason, the input and output types are the same.
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
}
