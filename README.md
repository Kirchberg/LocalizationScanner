# LocalizationScanner - Localization issue scanner for Apple platform projects

<img src="https://github.com/Kirchberg/LocalizationScanner/blob/master/Media/Preview.jpg?raw=true" alt="LocalizationScanner"/>

## 👨‍💻 Running the script

```bash
swift run LocalizationScanner [--file-extensions <file-extensions> ...] [--excluded-directories <excluded-directories> ...] [--output-file-name <output-file-name>] [<scan-path>]
```

## 🐊 Arguments

- `<scan-path>`: path to the directory to scan. (default: current directory)
- ```-f, --file-extensions <file-extensions>```: The file extensions to search for. (default: swift, xib, m, storyboard)
- ```-e, --excluded-directories <excluded-directories>```: The directories to exclude from the search. (default: Pods, Tests, UITests, UnitTests)
- ```-o, --output-file-name <output-file-name>```: The name of the output file. (default: output.txt)
- ```-h, --help```: Show help information.

## 😱 Non-localised strings

If you come across a file that uses non-localised strings but their use is necessary, there are commands to skip them when scanning:

- `locscanner:disable` and `locscanner:enable` - disables scanning in a given range
- `locscanner:ignore` - disables scanning for the whole file

### 🔭 Example:

```swift
final class ExampleImpl: Example {
    ...
    // locscanner:disable
    static let veryImportantName: String = "iPhone Kirchberg"
    // locscanner:enable
    ...
}
```

## 📝 Editing

When modifying the source code, you must invoke the following command:

```bash
swift build && swift run LocalizationScanner [--file-extensions <file-extensions> ...] [--excluded-directories <excluded-directories> ...] [--output-file-name <output-file-name>] [<scan-path>]
```

File output is in the `output.txt` file unless you specify otherwise.

## 🤯 Troubleshooting

If you don't build the utility with `swift build` or `swift run` commands, you need to delete the hidden folder `./build` and rebuild again. You can see the hidden folders by using the key combination: `Shift+⌘+.`.
