
final class ArticleController: ResourceRepresentable {

    private let view: ViewRenderer
    
    init(view: ViewRenderer) {
        self.view = view
    }

    func makeResource() -> Resource<Article> {
        return Resource(
            index: index,
            show: show
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        let page =  try Article.makeQuery().paginate(for: request).makeJSON()
        return try view.makeWithBase(request: request, path: "article-list", context: page)
    }

    func show(request: Request, article: Article) throws -> ResponseRepresentable {
        
        return try view.makeWithBase(request: request, path: "article", context: article.makeJSON())
    }
}
