import MySQL

struct SubContent: QueryRowResultType, Renderable {
    var name: String
    
    static func decodeRow(r: QueryRowResult) throws -> SubContent {
        return try SubContent(
            name: r <| "name"
        )
    }
}