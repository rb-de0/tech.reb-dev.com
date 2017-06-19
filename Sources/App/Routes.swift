import AuthProvider

final class Routes: RouteCollection {
    
    private let view: ViewRenderer
    private let hash: HashProtocol
    
    init(view: ViewRenderer, hash: HashProtocol) {
        self.view = view
        self.hash = hash
    }
    
    func build(_ builder: RouteBuilder) throws {
        
        // article
        builder.resource("/", ArticleController(view: view))
        builder.resource("/articles", ArticleController(view: view))
        
        // siteinfo
        builder.resource("/siteinfo", SiteInfoController(view: view))
        builder.resource("/subcontents", SubContentController(view: view))
        
        // login / logout
        builder.resource("/login", LoginController(view: view, hash: hash))
        builder.resource("/logout", LogoutController())
        
        let secureGroup = builder.grouped([
            RedirectableAuthMiddleware<User>(redirectPath: "/login"),
            CSRFMiddleware(hash: hash),
            SuccessMessageMiddleware()
        ])
        
        // admin
        secureGroup.resource("/new", ArticleRegisterController(view: view))
        secureGroup.resource("/edit", ArticleEditController(view: view))
        secureGroup.post("/edit", Article.parameter, handler: ArticleEditController(view: view).store)
        secureGroup.post("/delete", Article.parameter, handler: ArticleEditController(view: view).delete)
        
        secureGroup.resource("/subcontents/new", SubContentRegisterController(view: view))
        secureGroup.resource("/subcontents/edit", SubContentEditController(view: view))
        secureGroup.post("/subcontents/edit", Subcontent.parameter, handler: SubContentEditController(view: view).store)
        secureGroup.post("/subcontents/delete", Subcontent.parameter, handler: SubContentEditController(view: view).delete)
    }
}
