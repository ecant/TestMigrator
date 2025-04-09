import ArgumentParser
import Foundation
import MigratorLib

@main
struct TestMigratorCLI: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Migrate Quick specs to XCTest or Swift Testing")
    
    enum OutputType: String, ExpressibleByArgument, CaseIterable {
        case xctest
        case swifttesting
    }

    @Option(name: .long, help: "The migration output type: 'xctest' or 'swifttesting'.")
    var outputType: OutputType = .swifttesting
    
    @Option(name: .shortAndLong, help: "File path where migration output should be written.")
    var outputFile: URL
    
    @Argument(help: "File path to QuickSpec test file to migrate.")
    var inputFile: URL
    
    mutating func run() throws {
        guard FileManager.default.fileExists(atPath: inputFile.path) else {
            throw ValidationError("File does not exist at path: \(inputFile.path)")
        }
        
        let contents = try String(contentsOf: inputFile, encoding: .utf8)
        
        guard contents.contains("QuickSpec") else {
            throw ValidationError("File does not appear to be a QuickSpec: \(inputFile.path)")
        }
        
        let output: String
        switch outputType {
        case .swifttesting:
            output = Migrator.migrateToSwiftTesting(contents)
        case .xctest:
            output = Migrator.migrateToXCTest(contents)
        }
        
        try output.write(to: outputFile, atomically: true, encoding: .utf8)
    }
}

extension URL: @retroactive ExpressibleByArgument {
    public init?(argument: String) {
        self.init(fileURLWithPath: argument)
    }
}
