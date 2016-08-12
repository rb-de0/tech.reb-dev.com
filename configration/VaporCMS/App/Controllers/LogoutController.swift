import Vapor
import MySQL

class LogoutController: Controller{

    typealias Item = String
    
    private weak var application: Application!
    
    required init(application: Application) {
        self.application = application
    }

    func index(request: Request) throws -> ResponseRepresentable {
        let response = Response(redirect: "/login")

        // TODO: アップデートしたら直す
        response.headers["Set-Cookie"] = "vapor-session=hoge; max-age=0"
        return response
    }

    func store(request: Request) throws -> ResponseRepresentable {
        let response = Response(redirect: "/login")

        // TODO: アップデートしたら直す
        response.headers["Set-Cookie"] = "vapor-session=hoge; max-age=0"
        return response
    }
}