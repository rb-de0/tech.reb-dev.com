import Authentication
import HTTP

final class RedirectableAuthMiddleware<U: PasswordAuthenticatable>: Middleware {
    
    private let redirectPath: String
    
    init(redirectPath: String) {
        self.redirectPath = redirectPath
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        if request.auth.isAuthenticated(U.self) {
            return try next.respond(to: request)
        }
        
        return Response(redirect: redirectPath)
    }
}
