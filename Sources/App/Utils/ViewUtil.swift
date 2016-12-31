import Vapor
import HTTP
import Node
import Settings

class ViewUtil{

    private static var linkList = [Node]()
    
    private static weak var drop: Droplet!

    class func configure(config: Settings.Config, drop: Droplet){
        
        self.drop = drop
        
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

    class func contextIncludeHeader(request: Request, context: [String: Node], isSecure: Bool = false) -> Node{
        let subContentNames = SubContentAccessor.loadAll().map{$0.name}.map{Node($0)}
        let siteInfo = SiteInfoAccessor.load() ?? SiteInfo(id: 1, sitename: "vapor-cms", overview: "A simple cms server written by swift.")

        var includedContext = context
        includedContext["links"] = Node(linkList)
        includedContext["sitename"] = Node(siteInfo.sitename)
        includedContext["overview"] = Node(siteInfo.overview)
        includedContext["subcontentnames"] = Node(subContentNames)
        includedContext["has_session"] = Node(SessionManager.hasSession(request: request))
        
        if let token = SecureUtil.getAuthenticityToken(drop: drop, request: request), isSecure{
            includedContext["authenticity_token"] = token
        }
        
        return Node(includedContext)
    }
}
