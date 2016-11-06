import Vapor
import MySQL

class SiteInfoAccessor{
    
    class func load() -> SiteInfo? {
        do{
            let siteInfos: [SiteInfo] = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("SELECT * FROM siteinfo")
            }
            
            return siteInfos.first
        }catch{
            return nil
        }
    }
}

// MARK: - UPDATE
extension SiteInfoAccessor{
    class func update(id: String, input: SiteInfoInput) -> Bool{
        do{
            let _ = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("UPDATE siteinfo SET sitename=?, overview=? WHERE id=?", [input.sitename.value, input.overview.value, id])
            }
        }catch{
            return false
        }
        
        return true
    }
}

// MARK: - CREATE
extension SiteInfoAccessor{
    class func register(input: SiteInfoInput) -> Bool {
        do{
            let _ = try DatabaseUtil.connectionPool().execute { conn in
                try conn.query("INSERT INTO siteinfo (sitename, overview) VALUES (?,?)", [input.sitename.value, input.overview.value])
            }
        }catch{
            return false
        }
        
        return true
    }
}
