
final class SuccessMessageMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        if let message = request.query?["message"]?.int, let successMessage = SuccessMessage(rawValue: message)?.message {
            request.storage["success_message"] = successMessage
        }
        
        return try next.respond(to: request)
    }
}
