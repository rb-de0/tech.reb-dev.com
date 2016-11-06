import Vapor

let drop = Droplet(environment: .development)

DatabaseUtil.configure(config: drop.config)
ViewUtil.configure(config: drop.config, drop: drop)
TwitterManager.configure(config: drop.config)

// See: https://github.com/vapor/vapor/issues/502
// セッションCookieのPathが設定されていて辛いのでパスが怪しい

// ログイン
drop.resource("/login", LoginController(drop: drop))

// ログアウト
drop.resource("/logout", LogoutController(drop: drop))

// 記事編集
drop.resource("/edit", ArticleEditController(drop: drop))

// セッションが直ったら直したい
// app.resource("/edit/:page", controller: ArticleEditController.self)

// 記事投稿
drop.resource("/new", ArticleRegisterController(drop: drop))

// セッションが直ったら直したい
//app.resource("/new/:id", controller: ArticleRegisterController.self)

// 記事更新
drop.resource("/update", ArticleUpdateController(drop: drop))

// 記事詳細
drop.resource("/contents/:id", ArticleController(drop: drop))

// 記事一覧
drop.resource("/", ArticleListController(drop: drop))
drop.resource("/articles", ArticleListController(drop: drop))
drop.resource("/articles/page/:page", ArticleListController(drop: drop))

// 固定ページ
drop.resource("/subcontents/:name", SubContentController(drop: drop))
drop.resource("/edit-subcontents", SubContentEditController(drop: drop))
drop.resource("/new-subcontent", SubContentRegisterController(drop: drop))
drop.resource("/update-subcontent", SubContentUpdateController(drop: drop))

// サイト情報
drop.resource("/siteinfo", SiteInfoController(drop: drop))

drop.run()
