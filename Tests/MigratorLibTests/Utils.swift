import Foundation

func contents(_ fileName: String) -> String {
	let file = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent().appendingPathComponent(fileName, isDirectory: false)
	return try! String.init(contentsOf: file, encoding: .utf8)
}

extension String {
    var trimmed: String { self.trimmingCharacters(in: .whitespacesAndNewlines) }
}
