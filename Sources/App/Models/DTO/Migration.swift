import FluentProvider

final class Migration: Preparation {
    
    static func prepare(_ database: Database) throws {
        
        try database.transaction { con in
            try con.raw("ALTER TABLE articles ADD COLUMN created_at_after DATETIME;")
            try con.raw("UPDATE articles SET created_at_after = STR_TO_DATE(created_at, '%Y年%m月%d日 %H時%i分');")
            try con.raw("ALTER TABLE articles DROP COLUMN created_at;")
            try con.raw("ALTER TABLE articles CHANGE COLUMN created_at_after created_at DATETIME;")
            try con.raw("ALTER TABLE articles ADD COLUMN updated_at DATETIME;")
        }
    }
    
    static func revert(_ database: Database) throws {}
}
