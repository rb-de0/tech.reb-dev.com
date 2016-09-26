import MySQL

struct User: QueryRowResultType{
    var id: Int
    var name: String
    var password: String
    
    static func decodeRow(r: QueryRowResult) throws -> User {
        return try User(
            id: r <| "id",
            name: r <| "name",
            password: r <| "password"
        )
    }
}