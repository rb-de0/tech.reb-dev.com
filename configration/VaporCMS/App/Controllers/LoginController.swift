import Vapor
import MySQL

class LoginController: Controller {
    
    typealias Item = String
    
    private weak var application: Application!
    
    required init(application: Application) {
        self.application = application
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        guard !SessionManager.hasSession(request: request) else{            
            return Response(redirect: "/edit")
        }

        SecureUtil.setAuthenticityToken(application: application, request: request)

        return try self.application.view("login.mustache", context: ViewUtil.contextIncludeHeader(request: request, context: [:]))
    }
    
    func store(request: Request) throws -> ResponseRepresentable {

        guard SecureUtil.verifyAuthenticityToken(application: application, request: request) else{
            return "Invalid request"
        }

        do{
            let userInput = try UserInput(request: request)

            guard let loginUser = UserAccessor.isLoggedIn(application: application, input: userInput) else{
                let context = ViewUtil.contextIncludeHeader(request: request, context: ["error_message": "IDかパスワードが異なります。"])
                return try self.application.view("login.mustache", context: context)
            }

            request.session?["userid"] = String(loginUser.id)
            return Response(redirect: "/edit")

        }catch let validationError as ValidationErrorProtocol{
            return try self.application.view("login.mustache", context: ViewUtil.contextIncludeHeader(request: request, context: ["error_message": validationError.message]))
        }
    }
}