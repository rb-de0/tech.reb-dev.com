import Vapor
import HTTP

class ArticleListController: ResourceRepresentable{

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
        let page = Int(request.parameters["page"]?.string ?? "") ?? 0
        let articles = ArticleAccessor.loadPage(page: page)
        let hasNext = !ArticleAccessor.loadPage(page: page + 1).isEmpty
        let previous = page - 1
        let next = page + 1

        let viewArticles = articles.map{(article: Article) -> [String: Any] in
            var context = article.context()
            let partOfContent = SecureUtil.stringOfEscapedScript(html: article.content.take(n: 100))
            context.updateValue(partOfContent ,forKey: "part_of_content")
            return context
        }

        let context: [String: Any] = ["articles": viewArticles, "previous": previous, "next": next, "has_previous": previous != -1, "has_next": hasNext]

        return try self.drop.view.make("article-list")

        //return try self.application.view("article-list.mustache", context:  ViewUtil.contextIncludeHeader(request: request, context: context))
    }
}