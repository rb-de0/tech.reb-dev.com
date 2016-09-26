import Vapor
import MySQL

class UserAccessor{

    class func isLoggedIn(drop: Droplet, input: UserInput) -> User?{
        let hashed = try? drop.hash.make(input.password.value, key: nil)

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
