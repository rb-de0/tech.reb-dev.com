import Flock

extension Flock {
    
   public static let Cdeploy: [Task] = [
       CdeployTask(),
       CbuildTask(),
       CsetupTask()
   ]
}

extension Config {
    public static var configFiles = [String]()
}

class CdeployTask: Task {
   let name = "cdeploy"

   func run(on server: Server) throws {
        try invoke("deploy:git")
        try invoke("cdeploy:setup")
        try invoke("cdeploy:build")
        try invoke("deploy:link")
   }
}

class CbuildTask: Task {
    let name = "build"
    let namespace = "cdeploy"
    
    func run(on server: Server) throws {
        
        let buildPath: String
        
        if server.directoryExists(Paths.nextDirectory) {
            buildPath = Paths.nextDirectory
        } else {
            buildPath = Paths.currentDirectory
        }
        
        try server.within(buildPath) {
            try server.execute("source ~/.bash_profile; swift build -c release -Xlinker -L/usr/lib")
        }
    }
}

class CsetupTask: Task {
    let name = "setup"
    let namespace = "cdeploy"
    
    func run(on server: Server) throws {
        
        let buildPath: String
        
        if server.directoryExists(Paths.nextDirectory) {
            buildPath = Paths.nextDirectory
        } else {
            buildPath = Paths.currentDirectory
        }
        
        try server.within(buildPath) {
            for file in Config.configFiles {
                try server.execute("cp \(file) ./Config/development/")
            }
        }
    }
}
