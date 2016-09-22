import Vapor
import HTTP
import MySQL
import SwiftyMarkdownParser

class ArticleController: ResourceRepresentable {   

    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }

    func makeResource() -> Resource<String>{
        return Resource(
            index: index
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {

        guard let id = request.parameters["id"]?.string else{
            return try self.drop.view.make("article")
            //return try self.application.view("article.mustache", context: ["message": "エラー"])
        }

        guard let article = ArticleAccessor.load(id: id) else{
            return try self.drop.view.make("article")
            //return try self.application.view("article.mustache", context: ["message": "存在しない記事です。"])
        }

        let html = SecureUtil.stringOfEscapedScript(html: SwiftyMarkdownParser.Parser.generateHtml(from: article.content))
        let context: [String: Any] = ["title": article.title, "content": html, "createdAt": String(describing: article.createdAt)] 

        return try self.drop.view.make("article")
        //return try self.application.view("article.mustache", context: ViewUtil.contextIncludeHeader(request: request, context: context))
    }
}