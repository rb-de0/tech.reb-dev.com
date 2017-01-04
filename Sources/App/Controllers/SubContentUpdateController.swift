import Vapor
import HTTP

class SubContentUpdateController: ResourceRepresentable {
    
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

        // 誰でも編集可能なのでユーザーはチェックしない
        if let id = request.parameters["id"]?.string, let subContent = SubContentAccessor.loadContent(id: id){
            let context = ViewUtil.contextIncludeHeader(request: request, context: subContent.context(), isSecure: true)
            return try self.drop.view.make("subcontent-update", context)
        }
        
        return Response(redirect: "/subcontents/new")
    }

    func store(request: Request) throws -> ResponseRepresentable {

        guard SecureUtil.verifyAuthenticityToken(drop: self.drop, request: request) else{
            return "Invalid request"
        }

        guard SessionManager.hasSession(request: request) else{
            return Response(redirect: "/")
        }

        guard let id = request.data["id"]?.string else{
            return Response(redirect: "/subcontents/new")
        }
        
        var errorMessage = ""
        var successMessage = ""

        do{
            let subContentInput = try SubContentInput(request: request)
            let result = SubContentAccessor.update(id: id, input: subContentInput)

            (errorMessage, successMessage) = result ? ("", "更新しました") : ("更新失敗しました", "")
        }catch let validationError as ValidationErrorProtocol{

            (errorMessage, successMessage) = (validationError.message, "")            
        }

        let viewData: [String: Node] = [
            "id": Node(id),
            "name": Node(request.data["name"]?.string ?? ""),
            "content": Node(request.data["content"]?.string ?? ""),
            "error_message": Node(errorMessage), 
            "success_message": Node(successMessage)
        ]

        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData, isSecure: true)
        return try self.drop.view.make("subcontent-update", context)
    }
}
