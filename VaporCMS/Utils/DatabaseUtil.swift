import MySQL
import Settings

class DatabaseUtil{
    
    struct DataBaseOption: ConnectionOption{
        let host: String
        let port: Int
        let user: String
        let password: String
        let database: String
    }

    private static var options: DataBaseOption?

    class func configure(config: Settings.Config){
        let host = config["database", "host"]?.string ?? "localhost"
        let port = config["database", "port"]?.int ?? 3306
        let user = config["database", "user"]?.string ?? ""
        let password = config["database", "password"]?.string ?? ""
        let database = config["database", "database"]?.string ?? ""

        options = DataBaseOption(host: host, port: port, user: user, password: password, database: database)
    }
    
    class func connectionPool() -> ConnectionPool{
        guard let op = options else{
            fatalError("db is not configured")
        }

        return ConnectionPool(options: op)
    }
}