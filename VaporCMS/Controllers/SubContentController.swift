import Vapor
import HTTP
import MySQL
import SwiftyMarkdownParser

class SubContentController: ResourceRepresentable {   

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

        guard let name = request.parameters["name"]?.string else{
            return Response(status: .noContent, body: "no content")
        }

        guard let subContent = SubContentAccessor.loadContent(name: name) else{
            return Response(status: .noContent, body: "no content")
        }

        let html = SecureUtil.stringOfEscapedScript(html: SwiftyMarkdownParser.Parser.generateHtml(from: subContent.content))
        let viewData: [String: Node] = ["title": Node(subContent.name), "content": Node(html)] 
        let context = ViewUtil.contextIncludeHeader(request: request, context: viewData)

        return try self.drop.view.make("subcontent", context)
    }
}