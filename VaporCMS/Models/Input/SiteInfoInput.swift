import Vapor
import HTTP

struct SiteInfoInput{
    let sitename: Valid<Count<String>>
    let overview: Valid<Count<String>>
    
    init(request: Request) throws {
        sitename = try request.data["sitename"].validated(by: Count.containedIn(low: 1, high: 30))
        overview = try request.data["overview"].validated(by: Count.containedIn(low: 1, high: 200))
    }
}
