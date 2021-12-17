//
//  FootballAppTests.swift
//  FootballAppTests
//
//  Created by Anna Lazareva on 13.12.2021.
//

import XCTest
@testable import FootballApp

class ValidatorTests: XCTestCase {
    
    let emailTesting = ["hello", "cog@wheel", "'cogwheel the orange'@example.com", "123@$.xyz", "dog@hi.", "annalzrv@me.com", "hello@lo.l", "hello@l.ol"]

    let passwordTesting = ["123", "138238284230", "1873120392743", "210983fehbhebcne§   1", "vfdjnvkdfjnfv", "helloWorld1", "HelloWorld1!", "12345@!a"]

    func testExample_0_0() {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[0]), false)
    }

    func testExample_0_1() {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[1]), false)
    }

    func testExample_0_2() {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[2]), false)
    }

    func testExample_0_3() throws {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[3]), false)
    }

    func testExample_0_4() {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[4]), false)
    }
    

    func testExample_0_5() {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[5]), true)
    }

    func testExample_0_6() {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[6]), false)
    }
    

    func testExample_0_7() {
        XCTAssertEqual(Validator.isEmailValid(emailTesting[7]), true)
    }
    
    func testExample_1_0() {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[0]), false)
    }
    
    func testExample_1_1() {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[1]), false)
    }
    
    func testExample_1_2() {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[2]), false)
    }
    
    func testExample_1_3() throws {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[3]), false)
    }
    
    func testExample_1_4() {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[4]), false)
    }
    
    func testExample_1_5() {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[5]), false)
    }
    
    func testExample_1_6() {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[6]), true)
    }
    
    func testExample_1_7() {
        XCTAssertEqual(Validator.isPasswordValid(passwordTesting[7]), true)
    }
}
