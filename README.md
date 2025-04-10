# TestMigrator

**TestMigrator** is a command-line tool designed to assist in migrating Swift tests written with [Quick](https://github.com/Quick/Quick) to XCTest or the newer [Swift Testing](https://github.com/swiftlang/swift-testing) framework.

It leverages [Swift Syntax](https://github.com/swiftlang/swift-syntax) to parse and rewrite source code, simplifying the migration process and minimizing manual effort.

## Installation

To get started, clone this repository to your local machine. 

From the package directory, you can run the CLI tool and explore its options using the following command: 
```sh
swift run test-migrator-cli --help
```

To build a release version of the binary, use:
```sh
# Build the binary
swift build -c release
# Run the binary
.build/release/test-migrator-cli --help
``` 

## Usage

Run the following command to view all available options:
```sh
test-migrator-cli --help
```

For example:
```sh
test-migrator-cli --output-file SomeTests.swift SomeSpec.swift
```

This command analyzes the specified test file and generates a migrated version using XCTest or Swift Testing syntax (defaulting to Swift Testing).

## Purpose
The primary purpose of this tool is to _assist_ in migrating Quick specs. It automatically unrolls the nested structure of a Quick spec into standard tests using XCTest or Swift Testing. Doing this process manually — identifying all the `it` blocks and copying the logic they need from their ancestor blocks (`describe`, `context`, `beforeEach`, `afterEach`) — is time-consuming and error-prone.

However, the migrated output is not intended to be a fully functional, polished test file. You will likely need to make additional changes to ensure the test file builds and runs successfully, as well as refactor and clean up the output to address code duplication or improve readability. 

Think of this tool as a powerful starting point for your migration, not the final step.

## Known Limitations

* **Code Formatting**: The output may lack proper indentation and newlines. Handling proper trivia (such as whitespace and indentation) is a notoriously challenging problem in source code transformation. It is highly recommended to use a tool specializing in formatting, like [swift-format](https://github.com/swiftlang/swift-format), to clean up the output.
* **Nimble Expectations**: The tool does not translate [Nimble](https://github.com/Quick/Nimble) expectations into Swift Testing’s `#expect` macros.
* **Advanced Quick Features**: Advanced Quick features, including `AsyncSpec` and `Behavior`, are not supported at this time.
