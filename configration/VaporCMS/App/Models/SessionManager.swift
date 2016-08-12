import Vapor
import MySQL

class SessionManager{

    class func hasSession(request: Request) -> Bool{
        
        guard let userId = request.session?["userid"] else{
            return false
        }

        do{
            let users: [User] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM users WHERE id = ?", [userId])
            }

            return !users.isEmpty
        }catch{
            return false
        }
    }
}