import MySQL
import Vapor

protocol Renderable{
    func context() -> [String: Any]
}

extension Renderable{
    func context() -> [String: Any]{

        var dic = [String: Any]()
        let mirror = Mirror(reflecting: self)

        for child in mirror.children where child.label != nil{
            dic.updateValue(String(describing: child.value), forKey: child.label!)
        }

        return dic
    }
}

struct Article: QueryRowResultType, Renderable{
    var id: Int
    var title: String
    var content: String
    var isPublished: Bool
    var createdAt: SQLDate
    
    static func decodeRow(r: QueryRowResult) throws -> Article {
        return try Article(
            id: r <| "id",
            title: r <| "title",
            content: r <| "content",
            isPublished: r <| "is_published",
            createdAt: r <| "created_at"
        )
    }
}