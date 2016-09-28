import Vapor
import HTTP
import Node
import Settings

class ViewUtil{

    private static var linkList = [Node]()

    class func configure(config: Settings.Config){
        guard let linkArray = config["link", "linklist"]?.array else{
            return
        }

        let linkObjects = linkArray.flatMap{$0.object}

        linkList = linkObjects.map{(dictionary: [String: Polymorphic]) -> Node in
            var dic = [String: Node]()
            
            for (key, value) in dictionary{
                dic[key] = Node(value.string ?? "")
            }

            return Node(dic)
        }
    }

    class func contextIncludeHeader(request: Request, context: [String: Node]) -> Node{
        let subContentNames = SubContentAccessor.loadAll().map{$0.name}.map{Node($0)}

        var includedContext = context
        includedContext["links"] = Node(linkList)
        includedContext["subcontentnames"] = Node(subContentNames)
        includedContext["has_session"] = Node(SessionManager.hasSession(request: request))
        return Node(includedContext)
    }
}