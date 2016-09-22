import Vapor
import HTTP
import MySQL

class SessionManager{

    class func hasSession(request: Request) -> Bool{
        
        guard let userId = try? request.session().data["userid"]?.string else{
            return false
        }

        do{
            let users: [User] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM users WHERE id = ?", [userId as QueryParameter])
            }

            return !users.isEmpty
        }catch{
            return false
        }
    }
}
