import AuthProvider
import FluentProvider
import LeafProvider
import MySQLProvider
import MarkdownProvider
import RedisProvider
import Sessions

extension Config {
    public func setup() throws {
        // allow fuzzy conversions for these types
        // (add your own types here)
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupConfiguable()
        try setupProviders()
        try setupPreparations()
        
        try Link.load(config: self)
    }
    
    /// Configure providers
    private func setupProviders() throws {
        try addProvider(FluentProvider.Provider.self)
        try addProvider(MySQLProvider.Provider.self)
        try addProvider(LeafProvider.Provider.self)
        try addProvider(MarkdownProvider.Provider.self)
    }
    
    /// Configure configuable
    private func setupConfiguable() throws {
        let redisCache = try RedisCache(config: self)
        let sessions = CacheSessions(redisCache, defaultExpiration: 86400)
        
        addConfigurable(middleware: { _ in SessionsMiddleware(sessions) }, name: "redis-sessions")
        addConfigurable(middleware: { _ in PersistMiddleware(User.self) }, name: "persist-user")
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
        
        preparations.append(User.self)
        preparations.append(Article.self)
        preparations.append(Siteinfo.self)
        preparations.append(Subcontent.self)
        
        // migration
        if arguments.contains("migrate") {
            preparations.append(Migration.self)
        }
    }
}
