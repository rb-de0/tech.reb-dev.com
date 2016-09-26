import Vapor
import HTTP
import Node

class ViewUtil{
    class func contextIncludeHeader(request: Request, context: [String: Node]) -> Node{
        var includedContext = context
        includedContext["has_session"] = Node(SessionManager.hasSession(request: request))
        return Node(includedContext)
    }
}