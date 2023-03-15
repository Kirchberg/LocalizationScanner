//
//  Teplovisor.swift
//
//
//  Created by Kirill Kostarev
//

import Foundation
import ArgumentParser

/*
 Examples of strings that matches regular expression:

 @"Привет, меня зовут Кирилл и я написал этот скрипт!"
 let name = "Hi, my name is Kirill and I wrote this script!"
 var name = "Привет, меня зовут Кирилл и я написал этот скрипт!"
 static let name: String = "Привет, меня зовут Кирилл и я написал этот скрипт!"
 let name: String = "Hi, my name is Kirill and I wrote this script!"
 var name: String = "Привет, меня зовут Кирилл и я написал этот скрипт!"
 return "Hi, my name is Kirill and I wrote this script!"
 */

struct Teplovisor: ParsableCommand {

    // MARK: - Command line arguments

    // File extensions to search for
    @Option(name: .shortAndLong, help: "The file extensions to search for.")
    var fileExtensions: [String] = ["swift", "xib", "m", "storyboard"]

    // Directories to exclude from the search
    @Option(name: .shortAndLong, help: "The directories to exclude from the search.")
    var excludedDirectories: [String] = ["Pods", "Tests", "UITests", "UnitTests"]

    @Option(name: .shortAndLong, help: "The name of the output file.")
    var outputFileName: String = "output.txt"

    // Path of the directory to scan
    @Argument(help: "The path of the directory to scan.")
    var scanPath: String = "."

    // MARK: - Main

    func run() throws {
        // Create URL object for the directory to scan
        let dir = URL(fileURLWithPath: scanPath)

        print("🔍 Search started in \(dir.path)")

        // Record the script start time
        let startTime = Date()

        // Create a file enumerator for the specified directory
        let enumerator = FileManager.default.enumerator(
            at: dir,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        )

        // Ensure there are files in the directory
        guard let filePaths = enumerator?.allObjects as? [URL] else {
            print("🚫 Could not find any files in \(dir.path)")
            return
        }

        // Filter files by file extensions and excluded directories
        let filteredFiles = filePaths.filter {
            fileExtensions.contains($0.pathExtension) && !excludedDirectories.contains(where: $0.path.contains)
        }

        // Filter matched files using the isMatchedFile function
        let matchedFiles = filteredFiles.filter(isMatchedFile)

        // Define the output file URL and generate the output string
        let outputURL = URL(fileURLWithPath: outputFileName)
        let output = matchedFiles.map(\.path).joined(separator: "\n")

        if matchedFiles.isEmpty {
            print("🤙 No unlocalized files found in \(dir.path)")
        } else {
            print("👷‍♀️ 🚧 Found \(matchedFiles.count) unlocalized files in \(dir.path) 🚧 👷‍♂️")
        }

        print("📂 Scanned \(filteredFiles.count) files")
        print("🔍 Finished script in \(Date().timeIntervalSince(startTime))")

        // Save the results to an output file
        try? output.write(to: outputURL, atomically: true, encoding: .utf8)

        print("✅ Results saved to \(outputFileName)")
    }

    // MARK: - Private Types

    private enum Static {

        /*
         This regular expression matches any occurrence of a variable or constant declaration (including their assignments). The declaration
         can start with the keywords "@" "static let", "let", "var" or "return". It then matches the name of the variable or constant, which
         must start with a letter. Optionally, it matches a colon followed by whitespace and the string "String", indicating the variable or
         constant is of type String. Finally, it optionally matches an equals sign and whitespace, followed by a string enclosed in double
         quotes, which represents the initial value of the variable or constant.
         */
        static let regexPattern: String = #"(?:\@|static let |let |var |return )\s*?([a-zA-Z][a-zA-Z0-9])*\s*(?::\s*String\s*)?(?:[=]\s*)?\"(?:\\.|[^\\"])*\""#

        static let enableCommand: String = "// teplovisor:enable"
        static let disableCommand: String = "// teplovisor:disable"
        static let disableAllCommand: String = "// teplovisor:disable all"

    }

    // MARK: - Private Methods

    // Check if a file at a given URL is matched (has unlocalized strings)
    private func isMatchedFile(_ url: URL) -> Bool {

        // Read the file content
        guard let contents = try? String(contentsOf: url) else {
            return false
        }

        // Check if the file contains NSLocalizedString or disableAllCommand
        if contents.contains("NSLocalizedString(") || contents.contains(Static.disableAllCommand) {
            return false
        }

        // Check if the file matches the regex pattern
        guard contents.range(of: Static.regexPattern, options: .regularExpression) != nil else {
            return false
        }

        // Initialize search range, isEnabled flag, and teplovisorCommands flag
        var searchRange = contents.startIndex..<contents.endIndex
        var isEnabled = true
        var teplovisorCommands = false

        // Iterate through the file content to find disable and enable commands
        while let disableCommentRange = contents.range(of: Static.disableCommand, options: [], range: searchRange) {
            isEnabled = false
            teplovisorCommands = true
            searchRange = disableCommentRange.upperBound..<contents.endIndex

            // If an enable command is found, set isEnabled to true and update the search range
            if let enableCommentRange = contents.range(of: Static.enableCommand, options: [], range: searchRange) {
                isEnabled = true
                searchRange = enableCommentRange.upperBound..<contents.endIndex
            }
        }

        // Return true if no commands are found, or return !isEnabled to get unlocalized files when the check is disabled
        return !teplovisorCommands || !isEnabled
    }

}

Teplovisor.main()
