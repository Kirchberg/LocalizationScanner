# LocalizationScanner - Localization issue scanner for Apple platform projects

LocalizationScanner is a command-line tool that helps you identify localization issues in your Apple platform projects. It scans your project files for 
hardcoded strings and missing NSLocalizedString entries. This utility simplifies the localization process by providing an easy way to find potential 
issues and generate a report.

## Usage

```
swift run LocalizationScanner [--file-extensions <file-extensions> ...] [--excluded-directories <excluded-directories> ...] [--output-file-name <output-file-name>] [<scan-path>]
```

## Arguments
```<scan-path>```: The path of the directory to scan. (default: current directory)

## Options
- ```-f, --file-extensions <file-extensions>```: The file extensions to search for. (default: swift, xib, m, storyboard)
- ```-e, --excluded-directories <excluded-directories>```: The directories to exclude from the search. (default: Pods, Tests, UITests, UnitTests)
- ```-o, --output-file-name <output-file-name>```: The name of the output file. (default: output.txt)
- ```-h, --help```: Show help information.


keke
