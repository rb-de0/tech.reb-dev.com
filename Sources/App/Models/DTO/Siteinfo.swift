import FluentProvider
import Validation

final class Siteinfo: Model, JSONRepresentable {
    
    static let `default` = Siteinfo(sitename: "vapor-cms", overview: "A simple cms server written by swift.")
    
    static let entity = "siteinfo"
    
    let storage = Storage()
    var sitename: String
    var overview: String
    
    init(request: Request) throws {
        
        sitename = request.data["sitename"]?.string ?? ""
        overview = request.data["overview"]?.string ?? ""
        
        try validate()
    }
    
    func validate() throws {
        try sitename.validated(by: Count.containedIn(low: 1, high: 30))
        try overview.validated(by: Count.containedIn(low: 1, high: 200))
    }

    init(sitename: String, overview: String) {
        self.sitename = sitename
        self.overview = overview
    }
    
    required init(row: Row) throws {
        sitename = try row.get("sitename")
        overview = try row.get("overview")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("sitename", sitename)
        try row.set("overview", overview)
        return row
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set("sitename", sitename)
        try json.set("overview", overview)
        return json
    }
}

// MARK: - Preparation
extension Siteinfo: Preparation {
    
    static func prepare(_ database: Fluent.Database) throws {}
    
    static func revert(_ database: Fluent.Database) throws {}
}

extension Siteinfo: Updateable {
    
    func update(for req: Request) throws {
        
        sitename = req.data["sitename"]?.string ?? ""
        overview = req.data["overview"]?.string ?? ""

        try validate()
    }
    
    static var updateableKeys: [UpdateableKey<Siteinfo>] {
        return []
    }
}
