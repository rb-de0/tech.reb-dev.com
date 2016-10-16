import Vapor
import HTTP
import MySQL
import Node

class LoginController: ResourceRepresentable {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }

    func makeResource() -> Resource<String>{
        return Resource(
            index: index,
            store: store
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        guard !SessionManager.hasSession(request: request) else{            
            return Response(redirect: "/edit")
        }

        //SecureUtil.setAuthenticityToken(drop: self.drop, request: request)

        return try self.drop.view.make("login", ViewUtil.contextIncludeHeader(request: request, context: [:], isSecure: true))
    }
    
    func store(request: Request) throws -> ResponseRepresentable {

        guard SecureUtil.verifyAuthenticityToken(drop: self.drop, request: request) else{
            return "Invalid request"
        }

        do{
            let userInput = try UserInput(request: request)

            guard let loginUser = UserAccessor.isLoggedIn(drop: self.drop, input: userInput) else{
                let context = ViewUtil.contextIncludeHeader(request: request, context: ["error_message": Node("IDかパスワードが異なります。")])
                return try self.drop.view.make("login", context)
            }

            try! request.session().data["userid"] = Node(String(loginUser.id))
            return Response(redirect: "/edit")

        }catch let validationError as ValidationErrorProtocol{
            let context = ViewUtil.contextIncludeHeader(request: request, context: ["error_message": Node(validationError.message)])
            return try self.drop.view.make("login", context)
        }
    }
}
