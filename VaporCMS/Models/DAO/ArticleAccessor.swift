import MySQL
import Foundation

class ArticleAccessor{
    static let SELECT_UNIT = 20
}

// MARK: - UPDATE
extension ArticleAccessor{
    class func update(id: String, input: ArticleInput) -> Bool{
        do{
            let _ = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("UPDATE articles SET title=?, content=? WHERE id=?", [input.title.value, input.content.value, id])
            }
        }catch{
            return false
        }

        return true
    }
}

// MARK: - CREATE
extension ArticleAccessor{
    class func register(input: ArticleInput) -> (result: Bool, insertedId: Int) {
        do{
            let createdAt = Date()
            let queryStatus = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("INSERT INTO articles (title, content, created_at) VALUES (?,?,?)", [input.title.value, input.content.value, String(describing: createdAt)])
            }

            return (true, queryStatus.insertedId)
        }catch{
            return (false, -1)
        }        
    }
}

// MARK: - READ
extension ArticleAccessor{
    class func loadPage(page: Int) -> [Article]{
        do{
            let articles: [Article] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM articles ORDER BY id DESC LIMIT ?, ?", [SELECT_UNIT * page, SELECT_UNIT])
            }

            return articles
        }catch{
            return []
        }
    }

    class func load(id: String) -> Article?{
        do{
            let articles: [Article] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM articles WHERE id = ?", [String(id)])
            }
            return articles.first
        }catch{
            return nil
        }
    }
}
