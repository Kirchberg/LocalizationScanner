import XCTest

@testable import LocalizationScanner

final class LocalizationScannerTests: XCTestCase {

    func testObjectiveDeclaration() {
        let input = "@\"Привет, меня зовут Кирилл и я написал этот скрипт!\""
        checkRegexMatch(input: input, shouldMatch: true)
    }

    func testLetDeclaration() {
        let input = #"let name = "Hi, my name is Kirill and I wrote this script!""#
        checkRegexMatch(input: input, shouldMatch: true)
    }

    func testVarDeclaration() {
        let input = #"var name = "Привет, меня зовут Кирилл и я написал этот скрипт!""#
        checkRegexMatch(input: input, shouldMatch: true)
    }

    func testStaticLetDeclaration() {
        let input = #"static let name: String = "Привет, меня зовут Кирилл и я написал этот скрипт!""#
        checkRegexMatch(input: input, shouldMatch: true)
    }

    func testLetDeclarationWithType() {
        let input = #"let name: String = "Hi, my name is Kirill and I wrote this script!""#
        checkRegexMatch(input: input, shouldMatch: true)
    }

    func testVarDeclarationWithType() {
        let input = #"var name: String = "Привет, меня зовут Кирилл и я написал этот скрипт!""#
        checkRegexMatch(input: input, shouldMatch: true)
    }

    func testReturnStatement() {
        let input = #"return "Hi, my name is Kirill and I wrote this script!""#
        checkRegexMatch(input: input, shouldMatch: true)
    }

    func testIncorrectString() {
        let input = #"Hi, my name is Kirill and I wrote this script!"#
        checkRegexMatch(input: input, shouldMatch: false)
    }

    func testUnknownDeclaration() {
        let input = #"#import "KPGenreSelectItem.h""#
        checkRegexMatch(input: input, shouldMatch: false)
    }

    // MARK: - Private Properties

    private let regexPattern: String = LocalizationScanner.Static.regexPattern

    // MARK: - Private Methods

    private func checkRegexMatch(input: String, shouldMatch: Bool) {
        let match = input.range(of: regexPattern, options: .regularExpression)
        XCTAssertEqual(match != nil, shouldMatch, "Failed test for input: '\(input)'")
    }

}
