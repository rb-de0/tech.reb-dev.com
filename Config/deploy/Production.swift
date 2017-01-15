import Flock

class Production: Configuration {
    
	func configure() {
        Servers.add(SSHHost: "tech.reb-dev.com", roles: [.app, .db, .web])
	}
}
