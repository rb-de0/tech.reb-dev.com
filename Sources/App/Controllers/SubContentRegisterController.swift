
final class SubContentRegisterController: ResourceRepresentable {
    
    private let view: ViewRenderer
    
    init(view: ViewRenderer) {
        self.view = view
    }

    func makeResource() -> Resource<Subcontent>{
        return Resource(
            index: index,
            store: store
        )
    }
    
    func index(request: Request) throws -> ResponseRepresentable {
        
        return try view.makeWithBase(request: request, path: "subcontent-register")
    }

    func store(request: Request) throws -> ResponseRepresentable {


        do{
            
            let subContent = try Subcontent(request: request)
            try subContent.save()
            
            return Response(redirect: "/subcontents/edit/\(subContent.name)?message=\(SuccessMessage.subContentRegister)")

        } catch {

            let context: NodeRepresentable = [
                "name": request.data["name"]?.string ?? "",
                "content": request.data["content"]?.string ?? "",
                "error_message": error.localizedDescription
            ]
            
            return try view.makeWithBase(request: request, path: "subcontent-register", context: context)
        }
    }
}
