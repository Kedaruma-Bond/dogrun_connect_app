# DogrunConnectアプリ
ドッグランの利用記録アプリです。<br>
入場時、退場時にアプリ上のボタンを押してもらうことで利用記録をレコードとしてDBに記録します。<br>
今ドッグランを利用しているワンコをアプリ上で遠隔で確認することができるので、不要なトラブルの回避や、仲良しの仔と遭遇しやすくなりドッグランユーザーの利用満足度の向上が見込めます。<br>
ワンコのワンチンの接種証明書の写真をアプリに登録できるので、登録制ドッグランの登録時等の証明書が必要な場面で有用です。<br>
運営向けの管理者画面では利用記録のトレンドを確認できたり、アプリのTOP画面に配置された掲示板の掲示内容を操作して情報の周知を図ることができます。<br>
また、ユーザーに事前にアプリを登録してもらえていれば、来場時の登録手続きの簡略化が見込めます。<br>
<br>
![スクリーンショット 2023-02-27 14 42 01](https://user-images.githubusercontent.com/85489708/221483750-98e70dda-d0b6-4b3b-9ee6-7ff667281d58.JPG)
<br>
![mobile_screens](https://user-images.githubusercontent.com/85489708/221483864-73a14844-921c-4b20-a4dc-8c54872e1681.jpeg)
<br>
![p5c28bn9fqf829pvxl8s](https://user-images.githubusercontent.com/85489708/221483978-414a50d6-ff9a-47e5-811d-a09480c4ab7b.jpg)
<br>
![wxr0ztply7rv9450idlu](https://user-images.githubusercontent.com/85489708/221484023-1cac1d69-4f65-4ac3-84eb-6a398206fd3e.jpg)
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
  - 自分のワンコの利用状況を公開するかはユーザーの任意で選択可
- ワンコのプロフィール編集機能
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
  - ドッグランで出会ったワンコをフレンドリストに自動登録
  - 自分のワンコと相性などのメモを残せる

## テスト
---
- Rspec
  - 単体テスト(model) 
  - 機能テスト(request) 実装中
  - 統合テスト(system) 未実装
