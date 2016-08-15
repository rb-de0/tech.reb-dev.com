import PackageDescription

let package = Package(
    name: "VaporCMS",
    
    dependencies: [
        .Package(url: "https://github.com/qutheory/vapor.git", versions: Version(0,12,0)..<Version(0,12,1)),
        .Package(url: "https://github.com/qutheory/vapor-mustache.git", majorVersion: 0, minor: 8),
        .Package(url: "https://github.com/novi/mysql-swift.git", majorVersion: 0, minor: 2),
        .Package(url: "https://github.com/rb-de0/SwiftyMarkdownParser.git", majorVersion: 0, minor: 1)
    ],
    exclude: [
        "Config",
        "Public",
        "Resources",
        "Tests",
    ]
)
