
import Foundation


struct Payback {
    
    var firstName = ""
    var lastName = ""
    var createdAt = NSDate()
    var updatedAt = NSDate()
    var amount = 0.0
	
	var isValid: Bool {
		return count(firstName) > 0 && count(lastName) > 0 && amount > 0
	}
}
