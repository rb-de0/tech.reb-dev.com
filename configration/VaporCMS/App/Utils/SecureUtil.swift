import Vapor
import HTTP
import Node

class SecureUtil{

    class func setAuthenticityToken(drop: Droplet, request: Request){

        // スタートさせる...
        try! request.session().data["start"] = Node("hoge")

        let session = try! request.session()
        let id = session.identifier!
        let token = try! drop.hash.make(id, key: nil)

        try! request.session().data["authenticity_token"] = Node(token)
    }

    class func verifyAuthenticityToken(drop: Droplet, request: Request) -> Bool{
        guard let session = try? request.session(), let identifier = session.identifier else{
            return false
        }

        let token = try! drop.hash.make(identifier, key: nil)
        return session.data["authenticity_token"] == Node(token)
    }

    // mustacheでエスケープさせずに手動で一部エスケープ
    class func stringOfEscapedScript(html: String) -> String{
        return html.replacingOccurrences(of: "</script>", with: "&lt;/script&gt;").replacingOccurrences(of: "<script>", with: "&lt;script&gt;")
    }
}