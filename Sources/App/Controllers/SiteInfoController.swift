
final class SiteInfoController: ResourceRepresentable {
    
    private let view: ViewRenderer
    
    init(view: ViewRenderer) {
        self.view = view
    }
    
    func makeResource() -> Resource<Siteinfo> {
        return Resource(
            index: index,
            store: store
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        let siteInfo = try Siteinfo.makeQuery().first()?.makeJSON()
        return try view.makeWithBase(request: request, path: "siteinfo", context: siteInfo)
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        do {
            
            let siteInfo = try Siteinfo.makeQuery().first() ?? (try Siteinfo(request: request))
            try siteInfo.update(for: request)
            try siteInfo.validate()
            try siteInfo.save()
            
            return Response(redirect: "siteinfo?message=\(SuccessMessage.subContentUpdate)")
            
        } catch {
            
            let (errorMessage, successMessage) = (error.localizedDescription, "")

            let context: NodeRepresentable = [
                "sitename": request.data["sitename"]?.string ?? "",
                "overview": request.data["overview"]?.string ?? "",
                "error_message": errorMessage,
                "success_message": successMessage
            ]
            
            return try view.makeWithBase(request: request, path: "siteinfo", context: context)
        }
    }
}
