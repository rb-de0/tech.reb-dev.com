
final class LoginController: ResourceRepresentable {
    
    private let view: ViewRenderer
    private let hash: HashProtocol
    
    init(view: ViewRenderer, hash: HashProtocol) {
        self.view = view
        self.hash = hash
    }

    func makeResource() -> Resource<String>{
        return Resource(
            index: index,
            store: store
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        if request.auth.isAuthenticated(User.self) {
            return Response(redirect: "/edit")
        }
    
        return try view.makeWithBase(request: request, path: "login")
    }
    
    func store(request: Request) throws -> ResponseRepresentable {

        do {
            
            let credential = try request.userNamePassword(hash: hash)
            let user = try User.authenticate(credential)
            try user.persist(for: request)
            return Response(redirect: "/edit")
            
        } catch {
            
            return try view.makeWithBase(request: request, path: "login", context: ["error_message": error.localizedDescription])
        }
    }
}
