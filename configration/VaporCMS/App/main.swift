import Vapor
import VaporMustache

let provider = VaporMustache.Provider(withIncludes: [
    "header": "header.mustache"
])

let config = Config(environment: .development)
let app = Application(providers: [provider], config: config)

// See: https://github.com/vapor/vapor/issues/502
// セッションCookieのPathが設定されていて辛いのでパスが怪しい

// ログイン
app.resource("/login", controller: LoginController.self)

// ログアウト
app.resource("/logout", controller: LogoutController.self)

// 記事編集
app.resource("/edit", controller: ArticleEditController.self)

// セッションが直ったら直したい
// app.resource("/edit/:page", controller: ArticleEditController.self)

// 記事投稿
app.resource("/new", controller: ArticleRegisterController.self)

// セッションが直ったら直したい
//app.resource("/new/:id", controller: ArticleRegisterController.self)

// 記事更新
app.resource("/update", controller: ArticleUpdateController.self)

// 記事詳細
app.resource("/articles/detail/:id", controller: ArticleController.self)

// 記事一覧
app.resource("/", controller: ArticleListController.self)
app.resource("/articles", controller: ArticleListController.self)
app.resource("/articles/page/:page", controller: ArticleListController.self)

app.start()