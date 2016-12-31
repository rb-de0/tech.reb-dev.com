import Vapor
import HTTP
import Node

class SecureUtil{
    
    class func getAuthenticityToken(drop: Droplet, request: Request) -> Node?{
        
        // スタートさせる...
        try! request.session().data["start"] = Node("hoge")
        
        guard let session = try? request.session(), let identifier = session.identifier else{
            return nil
        }
        
        guard let token = try? drop.hash.make(identifier, key: nil) else{
            return nil
        }
        
        session.data["authenticity_token"] = Node(token)
        
        return Node(token)
    }

    class func verifyAuthenticityToken(drop: Droplet, request: Request) -> Bool{
        
        guard let session = try? request.session() else{
            return false
        }
        
        return session.data["authenticity_token"]?.string == request.data["authenticity_token"]?.string
    }

    // mustacheでエスケープさせずに手動で一部エスケープ
    class func stringOfEscapedScript(html: String) -> String{
        return html.replacingOccurrences(of: "</script>", with: "&lt;/script&gt;").replacingOccurrences(of: "<script>", with: "&lt;script&gt;")
    }
}
