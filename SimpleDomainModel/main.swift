//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

//print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

protocol CustomStringConvertible {
    var description : String {
        get
    }
}

protocol Mathematics {
    func add(_: Money) -> Money
    func subtract(_:Money) -> Money
}

extension Double {
    var USD: Money {
        return Money(amount: Int(self), currency: "USD")
    }
    var EUR: Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    var GBP: Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    var YEN: Money {
        return Money(amount: Int(self), currency: "YEN")
    }
}
////////////////////////////////////
// Money
//
public struct Money : CustomStringConvertible, Mathematics{
  public var amount : Int
  public var currency : String
    
  var description: String {
        return ("\(currency)\(Double(amount))")
    }
    
  public func convert(_ to: String) -> Money {
    var newAmount = 0
    
    if (self.currency == "USD"){
        switch to {
        case "CAN":
            newAmount = self.amount * 5 / 4
        case "GBP":
            newAmount = self.amount / 2
        case "EUR":
            newAmount = self.amount * 3 / 2
        default:
            newAmount = self.amount
        }
    }else if(self.currency == "CAN"){
        switch to {
        case "USD":
            newAmount = self.amount * 4 / 5
        case "GBP":
            newAmount = self.amount * 2 / 5
        case "EUR":
            newAmount = self.amount * 6 / 5
        default:
            newAmount = self.amount
        }
    }else if(self.currency == "EUR"){
        switch to{
        case "USD":
            newAmount = self.amount * 2 / 3
        case "GBP":
            newAmount = self.amount * 1 / 3
        case "CAN":
            newAmount = self.amount * 5 / 6
        default:
            newAmount = self.amount
        }
    }else{
        switch to {
        case "USD":
            newAmount = self.amount * 2
        case "EUR":
            newAmount = self.amount * 3
        case "CAN":
            newAmount = self.amount * 5 / 2
        default:
            newAmount = self.amount
        }
    }
    return Money(amount: newAmount, currency: to)
  }
  
  public func add(_ to: Money) -> Money {
    if(self.currency == to.currency){
        return Money(amount: self.amount + to.amount, currency: to.currency)
    }else{
        let newAmount = self.convert(to.currency).amount + to.amount
        return Money(amount: newAmount, currency: to.currency)
    }
  }
  public func subtract(_ from: Money) -> Money {
    if(self.currency == from.currency){
        return Money(amount: from.amount - self.amount, currency: from.currency)
    }else{
        let newAmount = self.convert(from.currency).amount - from.amount
        return Money(amount: newAmount, currency: from.currency)
    }
  }
}

////////////////////////////////////
// Job
//
open class Job : CustomStringConvertible {
  fileprivate var title : String
  fileprivate var type : JobType

  var description: String {
        return("Job:\(title), Income:\(calculateIncome(1000))")
  }
    
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
    
  //calculate annual income.
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type{
    case .Hourly(let hourlyPay):
        return Int(hourlyPay * Double(hours))
    case .Salary(let annualPay):
        return annualPay
    }
  }
  //calculate income given the percentage of income raise
  open func raise(_ amt : Double) {
    switch self.type{
    case .Hourly(let hourlyPay):
        self.type = JobType.Hourly(hourlyPay + amt)
    case .Salary(let annualPay):
        self.type = JobType.Salary(annualPay + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person : CustomStringConvertible{
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0
    
  var description: String {
        var job = ""
        var spouse = ""
        if (self._job != nil) {
            job = "\(String(describing: _job!.title))"
        } else {
            job = "Jobless"
        }
        if (self._spouse != nil) {
            spouse = "\(String(describing: _spouse!.firstName)) \(String(describing: _spouse!.lastName))"
        } else {
            spouse = "Single"
        }
        return ("[\(firstName) \(lastName), job: \(job), spouse: \(spouse)]")
    }
  
    fileprivate var _job : Job? = nil
  
  open var job : Job? {
    get {return _job}
    set(value) {
        if(age >= 16){
            _job = value
        }else{
            _job = nil
        }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse}
    set(value) {
        if(self.age >= 18){
            _spouse = value
        }else{
            _spouse = nil
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  //print a person's infomation
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family : CustomStringConvertible{
    
  fileprivate var members : [Person] = []
    
  var description: String {
        var familyMembers = "Family Members: \n"
        for person in 0...members.count {
            familyMembers += "\(members[person].description)"
        }
        return familyMembers
   }
    
  public init(spouse1: Person, spouse2: Person) {
    if(spouse1.spouse == nil && spouse2.spouse ==  nil){
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
        members.append(spouse1)
        members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    var result:Bool = false
    for person in members{
        if(person.age > 21){
            result = true
        }
    }
    if(result){
        members.append(child)
        child.age = 0
        
    }
    return result
  }
  
  open func householdIncome() -> Int {
    var totalIncome = 0
    for person in members{
        if(person.job != nil){
            totalIncome += (person.job?.calculateIncome(2000))!
        }
    }
    return totalIncome
  }
}





