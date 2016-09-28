import Vapor
import MySQL

class SubContentAccessor{

    class func loadAll() -> [SubContent]{
        do{
            let subContents: [SubContent] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM subcontents")
            }

            return subContents
        }catch{
            return []
        }
    }

    class func loadContent(name: String) -> SubContent?{
        do{
            let subContents: [SubContent] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM subcontents WHERE name = ?", [name])
            }

            return subContents.first
        }catch{
            return nil
        }
    }
}
