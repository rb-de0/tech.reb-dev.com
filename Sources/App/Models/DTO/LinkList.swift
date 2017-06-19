
struct Link {
    
    static var links = [JSON]()
    
    static func load(config: Config) throws {
        
        let linkJSON = try config.get("link") as JSON
        links = linkJSON["linklist"]?.array ?? []
    }
}
