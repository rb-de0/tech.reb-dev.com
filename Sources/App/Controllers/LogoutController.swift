
final class LogoutController: ResourceRepresentable {

    func makeResource() -> Resource<String> {
        return Resource(
            index: index,
            store: store
        )
    }

    func index(request: Request) throws -> ResponseRepresentable {
        request.session?.destroy()
        return Response(redirect: "/login")
    }

    func store(request: Request) throws -> ResponseRepresentable {
        request.session?.destroy()
        return Response(redirect: "/login")
    }
}
