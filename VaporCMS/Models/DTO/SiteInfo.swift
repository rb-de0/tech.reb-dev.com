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
}
