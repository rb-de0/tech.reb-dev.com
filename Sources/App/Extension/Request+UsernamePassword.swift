import Authentication
import Validation

extension Request {
    
    func userNamePassword(hash: HashProtocol) throws -> Password {
        
        let username = data["username"]?.string ?? ""
        let password = data["password"]?.string ?? ""
        
        try username.validated(by: Count.containedIn(low: 1, high: 20))
        try password.validated(by: Count.containedIn(low: 1, high: 20))
        
        guard let hashedPass = try? hash.make(password).makeString() else {
            throw Abort.badRequest
        }
        
        return Password(username: username, password: hashedPass)
    }
}
