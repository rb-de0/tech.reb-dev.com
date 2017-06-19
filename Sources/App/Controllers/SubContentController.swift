
final class SubContentController: ResourceRepresentable {
    
    private let view: ViewRenderer
    
    init(view: ViewRenderer) {
        self.view = view
    }
    
    func makeResource() -> Resource<Subcontent> {
        return Resource(
            show: show
        )
    }
    
    func show(request: Request, subContent: Subcontent) throws -> ResponseRepresentable {
        return try view.makeWithBase(request: request, path: "subcontent", context: subContent.makeJSON())
    }
}

