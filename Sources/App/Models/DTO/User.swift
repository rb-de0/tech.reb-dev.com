import Authentication
import AuthProvider
import FluentProvider

final class User: Model {
    
    let storage = Storage()
    let username: String
    let password: String
    
    required init(row: Row) throws {
        username = try row.get("name")
        password = try row.get("password")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", username)
        try row.set("password", password)
        return row
    }
}

// MARK: - Preparation
extension User: Preparation {
    
    static func prepare(_ database: Fluent.Database) throws {}
    
    static func revert(_ database: Fluent.Database) throws {}
}

// MARK: - SessionPersistable
extension User: SessionPersistable {}

// MARK: - PasswordAuthenticatable
extension User: PasswordAuthenticatable {
    
    static var usernameKey: String {
        return "name"
    }
}
