
extension ViewRenderer {
    
    func makeWithBase(request: Request, path: String, context: NodeRepresentable? = nil, title: String? = nil) throws -> View {
        
        let subContentNames = try Subcontent.all().map { $0.name }.map { Node.string($0) }
        let siteInfo = try Siteinfo.all().first ?? .default
        
        var includedContext = try context?.makeNode(in: ViewContext.shared) ?? .object([:])
        
        try includedContext.set("links", Link.links)
        try includedContext.set("sitename", siteInfo.sitename)
        try includedContext.set("overview", siteInfo.overview)
        try includedContext.set("subcontentnames", subContentNames)
        try includedContext.set("pagename", includedContext["pagename"]?.string ?? (title ?? siteInfo.sitename))

        if let csrfToken = request.storage["csrf_token"] as? String {
            try includedContext.set("csrf_token", csrfToken)
        }
        
        if let successMessage = request.storage["success_message"] as? String {
            try includedContext.set("success_message", successMessage)
        }
        
        return try make(path, includedContext)
    }
}
