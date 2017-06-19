import Foundation

final class CSRFMiddleware: Middleware {
    
    private let hash: HashProtocol
    
    init(hash: HashProtocol) {
        self.hash = hash
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Response {
        
        guard let session = request.session else {
            throw Abort.badRequest
        }
        
        if request.method == .post {
            
            guard let sessionToken = session.data["csrf_token"]?.string,
                let requestToken = request.data["csrf_token"]?.string else {
                    
                throw Abort.badRequest
            }
            
            guard requestToken == sessionToken else {
                throw Abort.badRequest
            }
        }
        
        let token: String
        
        if let existToken = session.data["csrf_token"]?.string {
            token = existToken
        } else {
            let uuid = UUID().uuidString
            let newToken = try hash.make(uuid + session.identifier).makeString()
            session.data["csrf_token"] = .string(newToken)
            token = newToken
        }
        
        request.storage["csrf_token"] = token
        
        let response = try next.respond(to: request)
        
        return response
    }
}
