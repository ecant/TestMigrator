import Foundation

extension String: @retroactive Error {}

extension FileManager {
    /// Finds the root directory of the Swift package where the calling file is located.
    /// Note: This works by finding the directory where the Package.swift file is located.
    func findPackageRootURL(from filePath: String = #filePath, maxLevelsToSearch: Int = 10) throws
        -> URL
    {
        var directory = URL(fileURLWithPath: filePath).deletingLastPathComponent()
        var level = 1

        repeat {
            let matchingFiles = try findFiles(at: directory, deepSearch: false) {
                $0.lastPathComponent.lowercased() == "Package.swift".lowercased()
            }

            if matchingFiles.isEmpty {
                directory = directory.deletingLastPathComponent()
                level += 1
                continue
            }

            return directory
        } while level <= maxLevelsToSearch

        throw "Could not find package root within \(maxLevelsToSearch) levels of given file path"
    }

    /// Finds all files in a directory at the given URL that match a given predicate. If deep search is true, then deeply searches all descendant directories as well.
    func findFiles(at url: URL, deepSearch: Bool, matchingPredicate predicate: (URL) -> Bool) throws
        -> [URL]
    {
        let keys: [URLResourceKey] = [.isRegularFileKey]
        let options: FileManager.DirectoryEnumerationOptions = .init(arrayLiteral: [
            .skipsHiddenFiles, .skipsPackageDescendants,
        ])
        .union(.init(arrayLiteral: deepSearch ? [] : [.skipsSubdirectoryDescendants]))

        guard
            let enumerator = FileManager.default.enumerator(
                at: url, includingPropertiesForKeys: keys, options: options)
        else {
            throw "Could not search for files at url: \(url.path)"
        }

        var files = [URL]()

        for case let fileURL as URL in enumerator {
            do {
                let fileAttributes = try fileURL.resourceValues(forKeys: Set(keys))
                guard fileAttributes.isRegularFile == true,
                    predicate(fileURL)
                else { continue }
                files.append(fileURL)
            } catch {
                print("ERROR: ", error, fileURL)
            }
        }

        return files
    }
}
