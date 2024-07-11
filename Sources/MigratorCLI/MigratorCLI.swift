import Foundation
import ArgumentParser
import MigratorLib

@main
struct MigratorCLI: ParsableCommand {
    @Argument(help: "The input file containing the QuickSpec(s) to convert. Relative to the current working directory.")
    var inputFile: String
    
    @Argument(help: "The output file where the tests converted to XCTest should be output. Relative to the current working directory. If not present, the input file will be modified in place.")
    var outputFile: String?
    
    mutating func run() throws {
        print("🎉 inputFile", inputFile)
        print("🎉 outputFile", outputFile)
        
        guard let inputFileURL = URL(string: FileManager.default.currentDirectoryPath) else {
            return
        }
        
//        let currentDir = URL(string: FileManager.default.currentDirectoryPath)!
//        let inputFileURL = URL(string: inputFile, relativeTo: currentDir)
        
//        print("🎉 currentDir", currentDir.absoluteString)
//        print("🎉 inputFileURL", inputFileURL?.absoluteString)

        
        
//        let cd = URL(string: FileManager.default.currentDirectoryPath, relativeTo: "")
        
        
        
        //        do {
        //            let config = try DownloadSchema.Config()
        //            try DownloadSchema.run(with: config)
        //        } catch {
        //            Logger.error("Error running Download Subcommand: ", error)
        //            throw error
        //        }
    }
}
