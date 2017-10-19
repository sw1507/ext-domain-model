//
//  extTests.swift
//  SimpleDomainModelTests
//
//  Created by YuanShaochen on 2017/10/19.
//  Copyright © 2017年 Ted Neward. All rights reserved.
//

import XCTest

import SimpleDomainModel

class extTests: XCTestCase {
    
    
    
    func testDescription() {
        let test1 = Money(amount: 1, currency:"USD")
        let test2 = Money(amount: 2, currency:"GBP")
        let test3 = Money(amount: 40, currency:"EUR")
        let test4 = Money(amount: 100, currency:"CAN")
        XCTAssert(test1.description == "USD1.0")
        XCTAssert(test2.description == "GBP2.0")
        XCTAssert(test3.description == "EUR40.0")
        XCTAssert(test4.description == "CAN100.0")
    }
    
    func testJobPerson() {
        let job = Job(title: "developer", type: Job.JobType.Hourly(25))
        XCTAssert(job.description == "Job:developer, Income:25000")
        
        let su = Person(firstName: "Su", lastName: "Wang", age: 28)
        su.job = Job(title: "developer", type: Job.JobType.Hourly(25))
        su.spouse = Person(firstName: "Shaochen", lastName: "Yuan", age: 28)
        XCTAssert(su.job != nil)
        XCTAssert(su.spouse != nil)
        XCTAssert(su.description == "[Su Wang, job: developer, spouse: Shaochen Yuan]")
        
        let annie = Person(firstName: "Anne", lastName: "Wong", age: 22)
        //annie.spouse = Person(firstName: "Haochen", lastName: "Su", age: 29)
        XCTAssert(annie.description == "[Anne Wong, job: Jobless, spouse: Single]")
    }
    
    func testExtension() {
        let test1 = Money(amount: 20, currency: "USD")
        let test2 = Money(amount: 50, currency: "GBP")
        let ext1 = 20.USD
        let ext2 = 50.GBP
        XCTAssert(test1.amount == ext1.amount && test1.currency == ext1.currency)
        XCTAssert(test2.amount == ext2.amount && test2.currency == ext2.currency)
    }
    
    func testMath() {
        let money1 = Money(amount: 4, currency: "USD")
        let money2 = Money(amount: 6, currency: "USD")
        let money3 = Money(amount: 1, currency: "USD")
        XCTAssert(money1.add(money2).amount == 10 && money2.add(money3).amount == 7)
        XCTAssert(money1.currency == money2.currency && money2.currency == money3.currency && money1.currency == money3.currency)
        
        let moneySub1 = Money(amount: 10, currency: "USD")
        let moneySub2 = Money(amount: 30, currency: "USD")
        let moneySub3 = Money(amount: 10, currency: "USD")
        XCTAssert(moneySub1.subtract(moneySub2).amount == 20 && moneySub2.subtract(moneySub3).amount == -20)
        XCTAssert(moneySub1.currency == moneySub2.currency && moneySub2.currency == moneySub3.currency && moneySub1.currency == moneySub3.currency)
    }
    
}
