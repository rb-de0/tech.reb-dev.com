import Vapor
import HTTP

class ViewUtil{
    class func contextIncludeHeader(request: Request, context: [String: Any]) -> [String: Any]{
        var includedContext = context
        includedContext["has_session"] = SessionManager.hasSession(request: request)
        return includedContext
    }
}