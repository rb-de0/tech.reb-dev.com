
final class SubContentEditController: ResourceRepresentable {
    
    private let view: ViewRenderer
    
    init(view: ViewRenderer) {
        self.view = view
    }
    
    func makeResource() -> Resource<Subcontent>{
        return Resource(
            index: index,
            show: show
        )
    }

    func index(request: Request) throws -> ResponseRepresentable {
        
        return try view.makeWithBase(request: request, path: "subcontent-edit")
    }
    
    func store(request: Request) throws -> ResponseRepresentable {
        
        let subContent = try request.parameters.next(Subcontent.self)
        
        do{
            
            try subContent.update(for: request)
            try subContent.validate()
            try subContent.save()

            return Response(redirect: "/subcontents/edit/\(subContent.name)?message=\(SuccessMessage.subContentUpdate)")
            
        } catch {
            
            let context: NodeRepresentable = [
                "name": subContent.name,
                "content": subContent.content,
                "error_message": error.localizedDescription
            ]
            
            return try view.makeWithBase(request: request, path: "subcontent-update", context: context)
        }
    }
    
    func show(request: Request, subContent: Subcontent) throws -> ResponseRepresentable {
        
        return try view.makeWithBase(request: request, path: "subcontent-update", context: subContent.makeJSON())
        
    }
    
    func delete(request: Request) throws -> ResponseRepresentable {
        
        let subContent = try request.parameters.next(Subcontent.self)
        
        try subContent.delete()
        
        return Response(redirect: "/subcontents/edit")
    }
}
