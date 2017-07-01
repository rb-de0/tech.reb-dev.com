import Poppo

final class TwitterClient {
    
    private let siteURL: String
    private let poppo: Poppo
    
    init(config: Config) throws {
        
        guard let twitterConfig = config["twitter"] else {
            fatalError("twitter.json Not found")
        }
        
        siteURL = try twitterConfig.get("siteUrl")
        
        poppo = Poppo(
            consumerKey: try twitterConfig.get("consumerKey"),
            consumerKeySecret: try twitterConfig.get("consumerKeySecret"),
            accessToken: try twitterConfig.get("accessToken"),
            accessTokenSecret: try twitterConfig.get("accessTokenSecret")
        )
    }
    
    func tweetNewRegister(title: String, articleId: Int){
        let message = "\(title) : \(siteURL)/articles/\(articleId)"
        poppo.tweet(status: message)
    }
}
