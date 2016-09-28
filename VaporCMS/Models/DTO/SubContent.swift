import MySQL
import Vapor

struct SubContent: QueryRowResultType, Renderable {
    var id: Int
    var name: String
    var content: String
    
    static func decodeRow(r: QueryRowResult) throws -> SubContent {
        return try SubContent(
            id: r <| "id",
            name: r <| "name",
            content: r <| "content"
        )
    }

    func escapedContext() -> [String: Node]{
        var context = [String: Node]()
        
        context = [
            "id": Node(id),
            "name": Node(SecureUtil.stringOfEscapedScript(html: name)),
            "content": Node(SecureUtil.stringOfEscapedScript(html: content))
        ]

        return context
    }
}