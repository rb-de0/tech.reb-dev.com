import Vapor
import HTTP

struct SubContentInput{
    let name: Valid<Count<String>>
    let content: Valid<Count<String>>

    init(request: Request) throws {
        name = try request.data["name"].validated(by: Count.containedIn(low: 1, high: 30))
        content = try request.data["content"].validated(by: Count.containedIn(low: 1, high: 10000))
    }
}