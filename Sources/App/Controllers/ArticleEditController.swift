
final class ArticleEditController: ResourceRepresentable {
    
    private let view: ViewRenderer
    
    init(view: ViewRenderer) {
        self.view = view
    }

    func makeResource() -> Resource<Article>{
        return Resource(
            index: index,
            show: show
        )
    }

    func index(request: Request) throws -> ResponseRepresentable {

        let page =  try Article.makeQuery().paginate(for: request).makeJSON()
        return try view.makeWithBase(request: request, path: "article-edit", context: page)
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        let article = try request.parameters.next(Article.self)
        
        guard let id = article.id?.int else {
            throw Abort.serverError
        }
        
        do {

            try article.update(for: request)
            try article.validate()
            try article.save()
            
            return Response(redirect: "/edit/\(id)?message=\(SuccessMessage.articleUpdate)")
            
        } catch {
            
            let context: NodeRepresentable = [
                "id": id,
                "title": article.title,
                "content": article.content,
                "error_message": error.localizedDescription
            ]
            
            return try view.makeWithBase(request: request, path: "article-update", context: context)
        }
    }
    
    func show(request: Request, article: Article) throws -> ResponseRepresentable {
        
        return try view.makeWithBase(request: request, path: "article-update", context: article.makeJSON())

    }
}
