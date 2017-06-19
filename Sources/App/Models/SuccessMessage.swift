
enum SuccessMessage: Int, CustomStringConvertible {
    
    case articleRegister
    case articleUpdate
    case subContentRegister
    case subContentUpdate
    case siteInfoUpdate
    
    var message: String {
        
        switch self {
        case .articleRegister, .subContentRegister:
            return "Registration success"
        case .articleUpdate, .subContentUpdate, .siteInfoUpdate:
            return "Update success"
        }
    }
    
    var description: String {
        return String(rawValue)
    }
}
