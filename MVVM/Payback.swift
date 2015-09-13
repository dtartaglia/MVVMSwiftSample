
import Foundation


struct Payback {
    
    var firstName = ""
    var lastName = ""
    var createdAt = NSDate()
    var updatedAt = NSDate()
    var amount = 0.0
	
	var isValid: Bool {
		return firstName.characters.count > 0 && lastName.characters.count > 0 && amount > 0
	}
}
