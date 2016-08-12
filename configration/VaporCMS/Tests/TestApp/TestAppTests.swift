import XCTest
@testable import TestApp

class TestAppTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(TestApp().text, "Hello, World!")
    }


    static var allTests : [(String, (TestAppTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
