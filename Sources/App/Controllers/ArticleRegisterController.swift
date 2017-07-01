
final class ArticleRegisterController: ResourceRepresentable {
    
    private let view: ViewRenderer
    private let twitterClient: TwitterClient
    
    init(view: ViewRenderer, twitterClient: TwitterClient) {
        self.view = view
        self.twitterClient = twitterClient
    }
    
    func makeResource() -> Resource<String>{
        return Resource(
            index: index,
            store: store
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        return try view.makeWithBase(request: request, path: "article-register")
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        do {
            
            let article = try Article(request: request)
            try article.save()

            guard let id = article.id?.int else {
                throw Abort.serverError
            }
            
            twitterClient.tweetNewRegister(title: article.title, articleId: id)
            
            return Response(redirect: "/edit/\(id)?message=\(SuccessMessage.articleRegister)")
            
        } catch {
            
            let context: NodeRepresentable = [
                "title": request.data["title"]?.string ?? "",
                "content": request.data["content"]?.string ?? "",
                "error_message": error.localizedDescription
            ]
            
             return try view.makeWithBase(request: request, path: "article-register", context: context)
        }
    }
}
