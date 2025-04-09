import ArgumentParser
import Foundation
import MigratorLib

@main
struct MigratorCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Migrate Quick specs to XCTest or Swift Testing")
    
    enum OutputMode: String, ExpressibleByArgument, CaseIterable {
        case xctest
        case swifttesting
    }

    @Option(name: .shortAndLong, help: "The migration output format: 'xctest' or 'swifttesting'.")
    var outputMode: OutputMode

    @Flag(name: .shortAndLong, help: "Modify files in place, overwriting the original content.")
    var inPlace: Bool = false
    
    @Argument(help: "Input files to process.")
    var inputFiles: [URL]
    
    mutating func run() throws {
        for file in inputFiles {
            guard FileManager.default.fileExists(atPath: file.path) else {
                throw ValidationError("File does not exist at path: \(file.path)")
            }
        }
        
        for file in inputFiles {
            let contents = try String(contentsOf: file, encoding: .utf8)
            
            guard contents.contains("QuickSpec") else {
                throw ValidationError("File does not appear to be a QuickSpec: \(file.path)")
            }
            
            let result: String
            switch outputMode {
            case .swifttesting:
                result = ""
            case .xctest:
                result = Migrator.migrateToXCTest(contents)
            }
                        
            let outputFile: URL
            if inPlace {
                outputFile = file
            } else {
                outputFile = file.deletingLastPathComponent()
                    .appendingPathComponent(file.lastPathComponent.replacingOccurrences(of: "Spec", with: "Tests"))
            }
            
            try result.write(to: outputFile, atomically: true, encoding: .utf8)
        }
    }
}

extension URL: @retroactive ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
}
