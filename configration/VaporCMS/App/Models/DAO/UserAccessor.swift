import Vapor
import MySQL

class UserAccessor{

    class func isLoggedIn(application: Application, input: UserInput) -> User?{
        let hashed = application.hash.make(input.password.value)

        do{
            let users: [User] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM users WHERE name = ? AND password = ?", [input.username.value, hashed])
            }

            return users.first
        }catch{
            return nil
        }
    }
}
