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
            let context = Node(["message": Node("エラー")])
            return try self.drop.view.make("article", context)
        }

        guard let article = ArticleAccessor.load(id: id) else{
            let context = Node(["message": Node("存在しない記事です。")])
            return try self.drop.view.make("article", context)
        }

        let html = SecureUtil.stringOfEscapedScript(html: SwiftyMarkdownParser.Parser.generateHtml(from: article.content))
        let viewData: [String: Node] = ["title": Node(article.title), "content": Node(html), "createdAt": Node(article.createdAt)] 
        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData)

        return try self.drop.view.make("article", context)
    }
}