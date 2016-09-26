import Vapor
import HTTP
import Node

class SecureUtil{

    class func setAuthenticityToken(drop: Droplet, request: Request){

        // スタートさせる...
        try! request.session().data["start"] = Node("hoge")

        guard let session = try? request.session(), let identifier = session.identifier else{
            return
        }

        guard let token = try? drop.hash.make(identifier, key: nil) else{
            return
        }

        try? request.session().data["authenticity_token"] = Node(token)
    }

    class func verifyAuthenticityToken(drop: Droplet, request: Request) -> Bool{
        
        guard let session = try? request.session(), let identifier = session.identifier else{
            return false
        }

        guard let token = try? drop.hash.make(identifier, key: nil) else{
            return false
        }

        return session.data["authenticity_token"] == Node(token)
    }

    // mustacheでエスケープさせずに手動で一部エスケープ
    class func stringOfEscapedScript(html: String) -> String{
        return html.replacingOccurrences(of: "</script>", with: "&lt;/script&gt;").replacingOccurrences(of: "<script>", with: "&lt;script&gt;")
    }
}