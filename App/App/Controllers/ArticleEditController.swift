import Vapor
import HTTP

class ArticleEditController: ResourceRepresentable {
    
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

        guard SessionManager.hasSession(request: request) else{
            let response = Response(redirect: "/login")
            return response
        }

        let page = Int(request.data["page"]?.string ?? "") ?? 0
        let articles = ArticleAccessor.loadPage(page: page)
        let hasNext = !ArticleAccessor.loadPage(page: page + 1).isEmpty
        let previous = page - 1
        let next = page + 1

        let viewArticles = articles.map{(article: Article) -> Node in
            var context = article.context()
            let partOfContent = SecureUtil.stringOfEscapedScript(html: article.content.take(n: 100))
            context.updateValue(Node(partOfContent) ,forKey: "part_of_content")
            return Node(context)
        }


        let viewData: [String: Node] = ["articles": Node(viewArticles), "previous": Node(previous), "next": Node(next), "has_previous": Node(previous != -1), "has_next": Node(hasNext)]
        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData)

        return try self.drop.view.make("article-edit", context)
    }
}