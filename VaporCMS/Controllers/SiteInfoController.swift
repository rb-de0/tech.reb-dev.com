import Vapor
import HTTP

class SiteInfoController: ResourceRepresentable {
    
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
        
        guard SessionManager.hasSession(request: request) else{
            let response = Response(redirect: "/login")
            return response
        }
        
        let context = SiteInfoAccessor.load()?.context() ?? [:]
        
        return try self.drop.view.make("siteinfo", ViewUtil.contextIncludeHeader(request: request, context: context, isSecure: true))
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        guard SecureUtil.verifyAuthenticityToken(drop: self.drop, request: request) else{
            return "Invalid request"
        }
        
        guard SessionManager.hasSession(request: request) else{
            return Response(redirect: "/")
        }
        
        var errorMessage = ""
        var successMessage = ""
        
        do{
            let siteInfoInput = try SiteInfoInput(request: request)
            let result = SiteInfoAccessor.register(input: siteInfoInput)

            (errorMessage, successMessage) = result ? ("", "更新しました") : ("更新失敗しました", "")
        }catch let validationError as ValidationErrorProtocol{
            (errorMessage, successMessage) = (validationError.message, "")
        }
        
        let viewData: [String: Node] = [
            "sitename": Node(request.data["sitename"]?.string ?? ""),
            "overview": Node(request.data["overview"]?.string ?? ""),
            "error_message": Node(errorMessage),
            "success_message": Node(successMessage)
        ]
        
        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData)
        
        return try self.drop.view.make("siteinfo", context)
    }
}
