//
//  SecretManagerTests.swift
//  TMDBTests
//
//  Created by Maxime Bentin on 20.12.23.
//

import XCTest

@testable import TMDB

final class SecretManagerTests: XCTestCase {
    func test_readTMDBAccessToken_success() {
        let secretManager = SecretManager()
        let testBundle = Bundle(for: type(of: self))
        let secrets: URL! = testBundle.url(forResource: "SecretTests", withExtension: "plist")
        let sut = secretManager.readTMDBAccessToken(file: secrets)
        XCTAssertEqual(sut, "TestValue")
    }

    func test_readTMDBAccessToken_missingKey_fails() {
        let secretManager = SecretManager()
        let testBundle = Bundle(for: type(of: self))
        let secrets: URL! = testBundle.url(forResource: "SecretTestsEmpty", withExtension: "plist")
        let sut = secretManager.readTMDBAccessToken(file: secrets)
        XCTAssertEqual(sut, "")
    }
}
