import UIKit

// The two account types required for implementation
enum AccountType {
    case savings
    case current
}
// A function that converts amount in Kobo to Naira and Strings it
func convertAmountToStringInNaira (of amountInKobo: Int) -> String {
    let amountInNaira = amountInKobo / 100
    return "\(amountInNaira)"
}
// Account class with withdrawal, deposit, charge and bonus methods
class Account {
    private(set)var id: Int // ENCAPSULATION to avoid access/tampering with sensitive data from external influences
    var customerId: Int
    var accountBalance: Int
    var interestRate: Double
    
    // Initialization required for the class
    init(id:Int, customerId:Int, accountBalance:Int, interestRate:Double) {
        self.id = id
        self.customerId = customerId
        self.accountBalance = accountBalance
        self.interestRate = interestRate
    }
    
    // Withdrawal method to reduce balance by amount to withdraw
    func withdrawal(of amountToWithdraw: Int) -> String {
        if accountBalance < amountToWithdraw {
            return "Insufficient Balance! Your withdrawal limit is #\(convertAmountToStringInNaira(of: accountBalance)). Thank you for banking with us."
        }
        accountBalance -= amountToWithdraw
        return "You have successfully withdrawn #\(convertAmountToStringInNaira(of: amountToWithdraw)), your balance is now #\(convertAmountToStringInNaira(of: accountBalance))."
    }
    
    // Deposit method to increment account balance by amount deposited
    func deposit( of amountDeposited: Int) -> String {
        accountBalance += amountDeposited
        print("\(convertAmountToStringInNaira(of: accountBalance))")
        return "You have successfully made a deposit of #\(convertAmountToStringInNaira(of: amountDeposited)) your balance is now #\(convertAmountToStringInNaira(of: accountBalance)). Thank you for banking with us."
    }
    
    func charge() -> String {
        accountBalance -= 10000
        return convertAmountToStringInNaira(of: accountBalance)
    }
    
    func bonus() -> String {
        accountBalance += 1000
        return convertAmountToStringInNaira(of: accountBalance)
    }
}


// POLYMORPHISM. The SavingsAccount and CurrentAccount classes are different forms in which an account was implemented
class SavingsAccount: Account {
    override var interestRate: Double {
        get { return 0.1 }
        set {}
    }
    
    override func deposit(of amountDeposited: Int) -> String {
        super.deposit(of: amountDeposited)
        super.bonus()
        return "Your deposit of #\((amountDeposited)/100) was successful. You have a bonus of #10, your account balance is now \(convertAmountToStringInNaira(of: accountBalance))"
    }
}

class CurrentAccount: Account {
    override var interestRate: Double {
        get { return 0.05 }
        set {}
    }
    override func withdrawal(of amountToWithdraw: Int) -> String {
        if accountBalance < amountToWithdraw + 10000 {
            return "Insufficient Balance!"
        }
        super.withdrawal(of: amountToWithdraw)
        super.charge()
        return " You have successfully withdrawn #\((amountToWithdraw)/100). #100 was charged on your transaction. Your account balance is now #\(convertAmountToStringInNaira(of: accountBalance)). Thank you for banking with us."
    }
}

// Customer class made use of the concept of ABSTRACTION in creating the current and savings accounts for the customer
class Customer {
    static var id: Int = 0
    
    private var _name: String
    var name: String {
        get { return _name }
        set { return _name = newValue }
    }
    
    private var _address: String
    var address: String {
        get { return _address }
        set { return _address = newValue }
    }
    
    private var _phoneNumber: String
    var phoneNumber: String {
        get { return _phoneNumber }
        set { _phoneNumber = newValue }
    }
    
    private var _optionalAccount: [Account]? = []
    var optionalAccount: [Account]? {
        get { return _optionalAccount }
        set { return _optionalAccount = newValue }
    }
    
    init(name: String, address: String, phoneNumber: String) {
        self._name = name
        self._address = address
        self._phoneNumber = phoneNumber
    }
    
    func accountBalance( _ account: Account) -> String {
        return convertAmountToStringInNaira(of: account.accountBalance)
    }
    func withdrawal (account: Account, amount: Int) -> String {
        account.withdrawal(of: amount)
    }
    
    func deposit(account: Account, amount: Int) -> String {
        account.deposit(of: amount)
    }
    //
    func openAccount(of type: AccountType) -> [Account] {
        switch type {
        case .savings:
            optionalAccount?.append(SavingsAccount(id:Int.random(in: 111...222), customerId: Int.random(in: 333...444), accountBalance: 0, interestRate: 0.10))
        case .current:
            optionalAccount?.append(CurrentAccount(id:Int.random(in: 555...666), customerId:Int.random(in: 777...888), accountBalance: 0, interestRate: 0.05))
        }
        print("Dear \(name), your \(type) Account has been successfully created. Thank you for banking with us.")
        return optionalAccount ?? []
    }
    
    // A method to close the accounts
    func closeAccount(accountToClose: Account) -> [ Account ] {
        optionalAccount?.removeAll(where: { $0.id == accountToClose.id })
        
        print("Your account has been closed successfully. Thank you for banking with us.")
        
        return optionalAccount ?? []
    }
}


var bimbo = Customer(name: "Bimbo", address: "dfgjnhgfhj", phoneNumber: "6795432456789")
var temi = Customer(name: "Tope", address: "Akinfenwa strrt", phoneNumber: "0802928891")
temi.openAccount(of: .savings) // The concept of ABSTRACTION was applied in the opening of the savings account
bimbo.openAccount(of: .savings)
var teni = temi.openAccount(of: .current)
var temAcc = temi.openAccount(of: .savings)
temi.closeAccount(accountToClose: temAcc[2])
