# DogrunConnectアプリ
ドッグランの利用記録アプリです。<br>
入場時、退場時にアプリ上のボタンを押してもらうことで利用記録をレコードとしてDBに記録します。<br>
今ドッグランを利用しているワンコをアプリ上で遠隔で確認することができるので、不要なトラブルの回避や、仲良しの仔と遭遇しやすくなりドッグランユーザーの利用満足度の向上が見込めます。<br>
ワンコの接種証明書の写真をアプリに登録できるので、登録制ドッグランの登録時等の証明書が必要な場面で有用です。<br>
運営向けの管理者画面では利用記録のトレンドを確認できたり、アプリのTOP画面に配置された掲示板の掲示内容を操作して情報の周知を図ることができます。<br>
<br>
![スクリーンショット 2022-08-30 11 28 32](https://user-images.githubusercontent.com/85489708/187335161-8e2c67e1-b6ac-4659-8788-4c546cc62dd0.JPG)
<br>
![mobile_view png 001](https://user-images.githubusercontent.com/85489708/187360202-870240ad-f177-464d-8e56-3c352401b54c.png)
<br>
![admin_view-1 png 002](https://user-images.githubusercontent.com/85489708/187360367-02045eed-3412-4b63-b267-302f35d032b7.png)
<br>
![admin_image-2 png 001](https://user-images.githubusercontent.com/85489708/187360435-a38397c9-f845-4fa9-9d1b-481c2757a079.png)
<br>

## 想定ユーザー
---
- ドッグランの利用者
- ドッグランの運営者

## URL
---
https://www.dogrunconnect.com

## 使用技術 
--- 
- Ruby 3.1.2
- Ruby on Rails 7.0.3
  - importmap
  - tailwindcss
  - clockwork
- puma
- Heroku (Hobby dynos)
  - Heroku Postgres 14.4
  - Cloudinary (add-on)
  - Papertrail
  - Heroku Scheduler
- aws
  - S3 (sitemapのアップロード)
- RSpec

## 機能一覧
---
- ユーザー登録、ログイン機能 (sorcery)
- ドッグラン利用(入退場)記録機能
- ドッグランの利用状況を遠隔監視機能
  - 自分のワンちゃんの利用状況を公開するかはユーザーの任意で選択可
- ワンちゃんのプロフィール編集機能
  - サムネイル画像投稿(active_storage)
- 管理者ユーザー用 入退場記録出力機能
  - 利用記録数をグラフ表示(chartkick)
  - 利用記録検索(ransack)
- 記事投稿機能
  - 利用者・運営側がドッグランに関する以下のような投稿ができる
    - 文＋写真添付可能な記事
    - SNS（Twitter、Facebook、Instagram）投稿埋め込み
  - 運営側で投稿内容を承認してアプリのTOP画面に掲示できる。
- エンカウントリスト機能
  - ドッグランで出会ったワンちゃんをフレンドリストに自動登録
  - 自分のワンちゃんと相性などのメモを残せる

## テスト
---
- Rspec
  - 単体テスト(model) 
  - 機能テスト(request) 未実装
  - 統合テスト(system) 未実装
