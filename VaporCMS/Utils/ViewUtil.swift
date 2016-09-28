import Vapor
import HTTP
import Node

class ViewUtil{
    class func contextIncludeHeader(request: Request, context: [String: Node]) -> Node{
        let subContentNames = SubContentAccessor.loadAll().map{$0.name}.map{Node($0)}

        var includedContext = context
        includedContext["subcontentnames"] = Node(subContentNames)
        includedContext["has_session"] = Node(SessionManager.hasSession(request: request))
        return Node(includedContext)
    }
}