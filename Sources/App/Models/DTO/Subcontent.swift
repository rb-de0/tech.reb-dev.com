import FluentProvider
import Validation

final class Subcontent: Model, JSONRepresentable {
    
    let storage = Storage()
    var name: String
    var content: String
    
    init(request: Request) throws {
        
        name = request.data["name"]?.string ?? ""
        content = request.data["content"]?.string ?? ""
        
        try validate()
    }
    
    func validate() throws {
        try name.validated(by: Count.containedIn(low: 1, high: 30))
        try content.validated(by: Count.containedIn(low: 1, high: 10000))
    }
    
    required init(row: Row) throws {
        name = try row.get("name")
        content = try row.get("content")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("name", name)
        try row.set("content", content)
        return row
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("name", name)
        try json.set("content", content)
        return json
    }
    
    static func make(for parameter: String) throws -> Subcontent {
        
        guard let subContent = try Subcontent.makeQuery().filter("name" == parameter).first() else {
            throw Abort(.notFound, reason: "No \(Subcontent.self) with that identifier was found.")
        }
        
        return subContent
    }
}

// MARK: - Preparation
extension Subcontent: Preparation {
    
    static func prepare(_ database: Fluent.Database) throws {}
    
    static func revert(_ database: Fluent.Database) throws {}
}

extension Subcontent: Updateable {
    
    func update(for req: Request) throws {
        
        name = req.data["name"]?.string ?? ""
        content = req.data["content"]?.string ?? ""
        
        try validate()
    }
    
    static var updateableKeys: [UpdateableKey<Subcontent>] {
        return []
    }
}
