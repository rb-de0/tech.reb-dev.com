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

        SecureUtil.setAuthenticityToken(drop: self.drop, request: request)

        // 誰でも編集可能なのでユーザーはチェックしない
        if let id = request.data["id"]?.string, let article = ArticleAccessor.load(id: id){
            let context = article.context()
            return try self.drop.view.make("article-update")
            //return try self.application.view("article-update.mustache", context: ViewUtil.contextIncludeHeader(request: request, context: context))
        }

        return try self.drop.view.make("article-update")
        //return try self.application.view("article-update.mustache", context: ViewUtil.contextIncludeHeader(request: request, context: [:]))
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

        let context: [String: Any] = [
            "id": id,
            "title": request.data["title"]?.string ?? "",
            "content": request.data["content"]?.string ?? "",
            "error_message": errorMessage, 
            "success_message": successMessage
        ]
        
        return try self.drop.view.make("article-update")
        //return try self.application.view("article-update.mustache", context: ViewUtil.contextIncludeHeader(request: request, context: context))
    }
}