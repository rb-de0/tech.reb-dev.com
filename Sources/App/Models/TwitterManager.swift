import Poppo
import Settings

class TwitterManager{

    static var poppo: Poppo?
    static var siteUrl: String?

    class func configure(config: Settings.Config){

        // わざとクラッシュさせる
        let consumerKey = config["auth", "consumerKey"]!.string!
        let consumerKeySecret = config["auth", "consumerKeySecret"]!.string!
        let accessToken = config["auth", "accessToken"]!.string!
        let accessTokenSecret = config["auth", "accessTokenSecret"]!.string!
        siteUrl = config["auth", "siteUrl"]?.string

        poppo = Poppo(
            consumerKey: consumerKey,
            consumerKeySecret: consumerKeySecret,
            accessToken: accessToken,
            accessTokenSecret: accessTokenSecret
        )
    }
}

extension TwitterManager{
    class func tweetNewRegister(title: String, id: Int){
        guard let url = siteUrl else{
            return
        }

        let message = "\(title) : \(url)/articles/\(id)"
        poppo?.tweet(status: message)
    }
}
