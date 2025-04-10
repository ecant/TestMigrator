import Foundation
import SwiftFormat
import SwiftSyntax

public enum Formatter {
    public static func format(source: String) throws -> String {
        let formatter = Self.createFormatter()
        var output = ""
        try formatter.format(source: source, assumingFileURL: nil, selection: .infinite, to: &output)
        return output
    }

    public static func formatAllSwiftFilesInPackage() throws {
        let packageDirectoryURL = try FileManager.default.findPackageRootURL()
        let swiftFiles = try FileManager.default.findFiles(at: packageDirectoryURL, deepSearch: true) { $0.pathExtension == "swift" }

        for file in swiftFiles {
            do {
                let formatter = Self.createFormatter()
                var output = ""
                try formatter.format(contentsOf: file, to: &output)
                try output.write(to: file, atomically: true, encoding: .utf8)
                print("✅ Formatted: \(file.lastPathComponent)")
            } catch {
                print("❌ Failed to format \(file.lastPathComponent): \(error)")
            }
        }
    }

    public static func formatExampleTestsFilesInPackage() throws {
        let packageDirectoryURL = try FileManager.default.findPackageRootURL()
        let swiftFiles = try FileManager.default.findFiles(at: packageDirectoryURL, deepSearch: true) {
            $0.pathExtension == "swift" && $0.path.contains("Example")
        }

        for file in swiftFiles {
            do {
                let formatter = Self.createFormatter()
                var output = ""
                try formatter.format(contentsOf: file, to: &output)
                try output.write(to: file, atomically: true, encoding: .utf8)
                print("✅ Formatted: \(file.lastPathComponent)")
            } catch {
                print("❌ Failed to format \(file.lastPathComponent): \(error)")
            }
        }
    }

    private static func createFormatter() -> SwiftFormatter {
        var config = SwiftFormat.Configuration()
        config.indentation = .spaces(4)
        config.tabWidth = 4
        config.lineLength = 160
        return SwiftFormatter(configuration: config)
    }
}
