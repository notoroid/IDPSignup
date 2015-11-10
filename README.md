IDPSingup
=====================

IDPSignup はBaaSの1つであるParseを利用したサインアップ機能を提供するためのスクリプトとiOSミドルウェア一式です。サポートしているmBaaSはParse,サーバーサイドはPHP、クライアントサイドはObjective-Cで構築されています。

#Install
クライアントのインストールにはiOS SDK用のパッケージインストーラー[cocoapods](http://cocoapods.org/)が必要です。
サーバーのインストールには[Parse PHP SDK](https://parse.com/docs/php/guide)、前述したSDKを使う際に
PHP用パッケージインストーラー[composer](https://getcomposer.org/)が必要となります。

##Parse のアカウント登録およびアプリケーション作成
Parse のアカウントが登録されていない場合はアカウント登録し、アプリケーションが未登録の場合は登録してください。


##サーバにServerフォルダの内容をコピー
プロジェクト内のServerフォルダのファイルをサーバのフォルダに配置します。他のソースコードと混在もできますがcomposer.jsonなど重複するファイルの上書きする可能性があるので別フォルダにコピーすることを奨励します。

##signup.phpの内容を修正
signup.phpを開きアプリケーションのSettingsのKeysから以下の値を置き換えてください。

<YOUR_PARSE_APPLICATION_ID> -> Application IDの内容
<YOUR_PARSE_REST_API_KEY> -> REST API Keyの内容
<YOUR_PARSE_MASTER_KEY> -> Master Keyの内容

signup.phpをファイル属性を変更し実行可能な状態にしてください。

##パッケージの導入
※composer をサーバへ導入済みを前提として説明しています。
ターミナルからサーバへ接続し、プロジェクト内のServerフォルダの内容を配置したフォルダに移動、以下のコマンドを入力してください。

composer.phar install

##Parse のアプリケーション設定
IDPSingupを導入するアプリに移動し、Coreに移動します。

###クラスの追加
Dataに遷移し以下のクラスを追加してください。
Invitation
InvitationCallback

###コンフィグの追加
Configに遷移し以下のパラメータを追加してください。
IDPInvitationURL ->サーバに配置したsignup.phpのパスを指定
IDPLoginScheme ->アプリケーションのURLScheme(後述)を指定

##iOSアプリcocoapodsの導入
xcodeのプロジェクト(xcodeproj) のあるフォルダにPodfileを作成してください。Podfileに以下の内容を記述してください。

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '[ターゲットのSDKバージョン]'

pod 'IDPSignup', :git => 'https://github.com/notoroid/IDPSignup.git'

既にPodfileがある場合は以下の内容を追記してください。
pod 'IDPSignup', :git => 'https://github.com/notoroid/IDPSignup.git'

Podfile 記述後、最初に導入する場合はターミナルからxcodeのプロジェクト(xcodeproj) のあるフォルダに移動後以下のコマンドを呼び出してください。

pod install

既にインストールしている場合はターミナルからxcodeのプロジェクト(xcodeproj) のあるフォルダに移動後以下のコマンドを呼び出してください。

pod update

##App Transport Security対応
配置したサーバがhttps通信かつTLSv1.2未対応ないしAppleが指定する通信方式以外の場合はATSを無効にする必要があります。info.plist の内容に以下を追記してください。

NSAppTransportSecurity(Dictionary)
NSAllowsArbitraryLoads(Boolean)
値:YES

##URLSchemeの追加
IDPSignupで起動するためのURLSchemeをアプリケーションに追記します。xcodeでアプリケーションのxcworkspaceをopenし、xcode上でアプリケーションのプロジェクトファイルを選択、TARGETSでアプリケーションを選択 - Info タブを選択URLTypesにサインアップ処理をハンドルするURLSchemeを記述してください。

URLSchemesで指定した文字列に://を付加したものをParseのConfigのIDPLoginScheme に記述します。

例:
signupdemo
をURLSchemeに指定した場合、
IDPLoginSchemeに
signupdemo://
を指定します。

##AppDelegate にハンドル記述
招待先がメールアドレスおよびユーザー名を受け取れるようにAppDelegateにハンドルを追記します。

AppDelegate にimport定義を追記してください。
#import <IDPSignup/IDPSignup.h>

AppDelegate にapplication: openURL: options: メソッドを追記してください。

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    [[IDPSignupManager defaultManager] handleOpenURL:url options:options signupHandle:^{
        
    } completion:^(NSError *error,NSString *username, NSString *email) {

    }];
    
    return YES;
}

## 招待コード生成機能を記述
招待コードを生成するソースコードににimport定義を追記してください。
#import <IDPSignup/IDPSignup.h>

[[IDPSignupManager defaultManager] signupInviteWithUsername:[ユーザー名] mail:[メールアドレス] options:nil pageResources:nil completion:^(NSError *error, NSURL *URL) {

    if( error == nil ){

    }
}];


