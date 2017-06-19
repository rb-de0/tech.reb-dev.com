@_exported import Vapor

extension Droplet {
    public func setup() throws {
        try collection(Routes(view: view, hash: hash))
    }
}
