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

    class func loadContent(id: String) -> SubContent?{
        do{
            let subContents: [SubContent] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM subcontents WHERE id = ?", [id])
            }

            return subContents.first
        }catch{
            return nil
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

// MARK: - UPDATE
extension SubContentAccessor{
    class func update(id: String, input: SubContentInput) -> Bool{
        do{
            let _ = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("UPDATE subcontents SET name=?, content=? WHERE id=?", [input.name.value, input.content.value, id])
            }
        }catch{
            return false
        }

        return true
    }
}

// MARK: - CREATE
extension SubContentAccessor{
    class func register(input: SubContentInput) -> Bool {
        do{
            let _ = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("INSERT INTO subcontents (name, content) VALUES (?,?)", [input.name.value, input.content.value])
            }
        }catch{
            return false
        }

        return true
    }
}