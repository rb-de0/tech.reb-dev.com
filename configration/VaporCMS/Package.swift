import PackageDescription

let package = Package(
    name: "VaporCMS",
    
    dependencies: [
        .Package(url: "https://github.com/rb-de0/vapor.git", majorVersion: 1, minor: 0),
        .Package(url: "https://github.com/novi/mysql-swift.git", majorVersion: 0, minor: 5),
        .Package(url: "https://github.com/rb-de0/SwiftyMarkdownParser.git", majorVersion: 0, minor: 2)
    ],
    exclude: [
        "Config",
        "Public",
        "Resources",
        "Tests",
    ]
)
