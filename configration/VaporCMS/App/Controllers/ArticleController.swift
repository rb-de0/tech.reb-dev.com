import Vapor
import MySQL

class ArticleController: Controller {
    
    typealias Item = String
    
    private weak var application: Application!
    
    required init(application: Application) {
        self.application = application
    }
    
    func index(request: Request) throws -> ResponseRepresentable {

        guard let id = request.parameters["id"] else{
            return try self.application.view("article.mustache", context: ["message": "エラー"])
        }

        guard let article = ArticleAccessor.load(id: id) else{
            return try self.application.view("article.mustache", context: ["message": "存在しない記事です。"])
        }

        let context: [String: Any] = ["title": article.title, "content": article.content, "createdAt": String(article.createdAt)]        
        return try self.application.view("article.mustache", context: ViewUtil.contextIncludeHeader(request: request, context: context))
    }
}