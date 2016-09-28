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

        SecureUtil.setAuthenticityToken(drop: self.drop, request: request)

        // 誰でも編集可能なのでユーザーはチェックしない
        if let id = request.data["id"]?.string, let subContent = SubContentAccessor.loadContent(id: id){
            let context = ViewUtil.contextIncludeHeader(request: request, context: subContent.escapedContext())
            return try self.drop.view.make("subcontent-update", context)
        }

        return Response(redirect: "/new-subcontent")
    }

    func store(request: Request) throws -> ResponseRepresentable {

        guard SecureUtil.verifyAuthenticityToken(drop: self.drop, request: request) else{
            return "Invalid request"
        }

        guard SessionManager.hasSession(request: request) else{
            return Response(redirect: "/")
        }

        guard let id = request.data["id"]?.string else{
            return Response(redirect: "/new-subcontent")
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
            "title": Node(request.data["name"]?.string ?? ""),
            "content": Node(request.data["content"]?.string ?? ""),
            "error_message": Node(errorMessage), 
            "success_message": Node(successMessage)
        ]

        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData)

        return try self.drop.view.make("subcontent-update", context)
    }
}