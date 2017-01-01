import Vapor

let drop = Droplet(environment: .development)

DatabaseUtil.configure(config: drop.config)
ViewUtil.configure(config: drop.config, drop: drop)
TwitterManager.configure(config: drop.config)


// ログイン
drop.resource("/login", LoginController(drop: drop))

// ログアウト
drop.resource("/logout", LogoutController(drop: drop))

// 記事編集
drop.resource("/edit", ArticleEditController(drop: drop))
drop.resource("/edit/:page", ArticleEditController(drop: drop))

// 記事投稿
drop.resource("/new", ArticleRegisterController(drop: drop))

// 記事更新
drop.resource("/update/:id", ArticleUpdateController(drop: drop))

// 記事詳細
drop.resource("/articles/:id", ArticleController(drop: drop))

// 記事一覧
drop.resource("/", ArticleListController(drop: drop))
drop.resource("/articles", ArticleListController(drop: drop))
//drop.resource("/articles/:page", ArticleListController(drop: drop))

// 固定ページ
drop.resource("/subcontents/:name", SubContentController(drop: drop))
drop.resource("/subcontents/edit", SubContentEditController(drop: drop))
drop.resource("/subcontents/new", SubContentRegisterController(drop: drop))
drop.resource("/subcontent/update/:page", SubContentUpdateController(drop: drop))

// サイト情報
drop.resource("/siteinfo", SiteInfoController(drop: drop))

drop.run()
