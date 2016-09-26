import Vapor
import HTTP

struct ArticleInput{
    let title: Valid<Count<String>>
    let content: Valid<Count<String>>

    init(request: Request) throws {
        title = try request.data["title"].validated(by: Count.containedIn(low: 1, high: 100))
        content = try request.data["content"].validated(by: Count.containedIn(low: 1, high: 10000))
    }
}