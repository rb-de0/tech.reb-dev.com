import Vapor
import HTTP

class SubContentEditController: ResourceRepresentable {
    
    private weak var drop: Droplet!
    
    init(drop: Droplet) {
        self.drop = drop
    }

    func makeResource() -> Resource<String>{
        return Resource(
            index: index
        )
    }

    func index(request: Request) throws -> ResponseRepresentable {

        guard SessionManager.hasSession(request: request) else{
            let response = Response(redirect: "/login")
            return response
        }

        let subContents = SubContentAccessor.loadAll()

        let viewArticles = subContents.map{(subcontent: SubContent) -> Node in
            var context = subcontent.context()
            let partOfContent = SecureUtil.stringOfEscapedScript(html: subcontent.content.take(n: 100))
            context.updateValue(Node(partOfContent) ,forKey: "part_of_content")
            return Node(context)
        }

        let viewData: [String: Node] = ["subcontents": Node(viewArticles)]
        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData)

        return try self.drop.view.make("subcontent-edit", context)
    }
}
