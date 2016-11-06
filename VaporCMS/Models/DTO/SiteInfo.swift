import MySQL
import Vapor

struct SiteInfo: QueryRowResultType, Renderable {
    var id: Int
    var sitename: String
    var overview: String
    
    static func decodeRow(r: QueryRowResult) throws -> SiteInfo {
        return try SiteInfo(
            id: r <| "id",
            sitename: r <| "sitename",
            overview: r <| "overview"
        )
    }
    
    func escapedContext() -> [String: Node]{
        var context = [String: Node]()
        
        context = [
            "id": Node(id),
            "sitename": Node(SecureUtil.stringOfEscapedScript(html: sitename)),
            "overview": Node(SecureUtil.stringOfEscapedScript(html: overview))
        ]
        
        return context
    }
}
