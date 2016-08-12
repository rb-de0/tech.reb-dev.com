import Vapor

class ArticleListController: Controller{

    typealias Item = String
    
    private weak var application: Application!
    
    required init(application: Application) {
        self.application = application
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        let page = Int(request.parameters["page"] ?? "") ?? 0
        let articles = ArticleAccessor.loadPage(page: page)
        let hasNext = !ArticleAccessor.loadPage(page: page + 1).isEmpty
        let previous = page - 1
        let next = page + 1

        let viewArticles = articles.map{(article: Article) -> [String: Any] in
            var context = article.context()
            context.updateValue(article.content.take(n: 100) ,forKey: "part_of_content")
            return context
        }

        let context: [String: Any] = ["articles": viewArticles, "previous": previous, "next": next, "has_previous": previous != -1, "has_next": hasNext]
        return try self.application.view("article-list.mustache", context:  ViewUtil.contextIncludeHeader(request: request, context: context))
    }
}