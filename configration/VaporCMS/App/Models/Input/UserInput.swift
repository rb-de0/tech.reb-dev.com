import Vapor
import HTTP

struct UserInput{
    let username: Valid<Count<String>>
    let password: Valid<Count<String>>

    init(request: Request) throws {
        username = try request.data["username"].validated(by: Count.containedIn(low: 1, high: 20))
        password = try request.data["password"].validated(by: Count.containedIn(low: 1, high: 20))
    }
}