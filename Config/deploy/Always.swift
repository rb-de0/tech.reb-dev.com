import Flock

class Always: Configuration {
    
	func configure() {
        
		Config.projectName = "tech.reb-dev.com"
		Config.executableName = "App"
		Config.repoURL = "https://github.com/rb-de0/tech.reb-dev.com"
		
		// Optional config:
		Config.deployDirectory = "/var/www/vapor"
        Config.configFiles = [
            "\(Config.deployDirectory)/\(Config.projectName)/shared/auth.json",
            "\(Config.deployDirectory)/\(Config.projectName)/shared/database.json",
            "\(Config.deployDirectory)/\(Config.projectName)/shared/link.json"
        ]
	}
}
