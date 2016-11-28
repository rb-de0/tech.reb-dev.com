import Vapor
import HTTP

class ArticleUpdateController: ResourceRepresentable {
    
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
        if let id = request.data["id"]?.string, let article = ArticleAccessor.load(id: id){
            let context = ViewUtil.contextIncludeHeader(request: request, context: article.context(), isSecure: true)
            return try self.drop.view.make("article-update", context)
        }

        return Response(redirect: "/new")
    }

    func store(request: Request) throws -> ResponseRepresentable {

        guard SecureUtil.verifyAuthenticityToken(drop: self.drop, request: request) else{
            return "Invalid request"
        }

        guard SessionManager.hasSession(request: request) else{
            return Response(redirect: "/")
        }

        guard let id = request.data["id"]?.string else{
            return Response(redirect: "/new")
        }

        var errorMessage = ""
        var successMessage = ""

        do{
            let articleInput = try ArticleInput(request: request)
            let result = ArticleAccessor.update(id: id, input: articleInput)

            (errorMessage, successMessage) = result ? ("", "更新しました") : ("更新失敗しました", "")
        }catch let validationError as ValidationErrorProtocol{
            // てきとー^^
            (errorMessage, successMessage) = (validationError.message, "")
        }

        let viewData: [String: Node] = [
            "id": Node(id),
            "title": Node(request.data["title"]?.string ?? ""),
            "content": Node(request.data["content"]?.string ?? ""),
            "error_message": Node(errorMessage), 
            "success_message": Node(successMessage)
        ]

        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData)
        
        return try self.drop.view.make("article-update", context)
    }
}
