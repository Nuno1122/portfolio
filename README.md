# portfolio
## ■ サービス概要
　「質の良い朝活を楽しく継続するため」という軸の元に考えたサービスです。
　　朝活を継続していることを視覚的に楽しみ、積み上げてる実感が欲しい。
 　毎日の朝活記録を後で見返した時に、少しでも積み上がっている、
 　成長している実感を得られるような感覚を楽しめるように考えました。

## ■メインのターゲットユーザー
　・アサカツに興味がある人
　・朝活を最近始めて、継続させたい人

## ■ユーザーが抱える課題
　・朝活が続かない。
　・既存のものでログをグラフなど視覚的に記録するものが見当たらない
　・
## ■解決方法
　・朝活を続ける工夫として、「朝起きて何を行うか？」が定められてないと続かないので、学習開始して行う１つのこ　　とを決める。
　・学習開始時刻をユーザー自身で決める
　・打刻したログをカレンダーに表示（積み上げ実感効果）
　・学習開始した時刻をグラフ化（学習開始時刻の視覚化）
　・他ユーザーの打刻ログを一覧化させて、日毎にどのユーザーが何時に打刻したのかを確認できるようにする
　　→（モチベーション効果）
　・打刻数、継続打刻でランキング化（順位付でモチベーションを上げる）

<追加予定>
　・学習開始ボタンを押した後に、タイマーで時間を測り、棒グラフで出力させる（積み上げを実感させる）
　・日の出時間をAPIを使い出力し、日光を浴びるきっかけを作る
　　　**【おはこん番地は！？API】**
　　　http://labs.bitmeister.jp/ohakon/index.cgi
　　**緯度/経度はどうやって取得するか？**
　　GPSは持ってない→住所から取得する
   **住所から緯度/経度はどうやって取得するか？**
 　 GoogleMAPのWebAPIがある。[Geocoding API](https://developers.google.com/maps/docume  
 　ntation/geocoding/start?hl=ja)郵便番号からも緯度/経度を取得できるようだ。精度は高くないみたいだが、　一旦これで予定
　・朝活ルーティーンをタスク化させて、打刻後すぐに着手できるよう表示させる。
　　（習慣化作りのきっかけを作る）
　・朝活におすすめの音楽をyoutubeで引っ張ってくる。投稿型にして、学習開始直後、すぐ流せるようにする。
　・他ユーザーをお気に入り登録（他ユーザーの打刻状況や、積み上げ状況、やることを閲覧できる）

## ■実装予定の機能
　・一般ユーザー
　　・未登録ユーザー
　　　・ユーザー登録機能（名前・パスワード・メールアドレス）
　　　・ランキング表示（連続継続日数ランキング、月別合計ランキング）
　　　・他のユーザー打刻一覧の確認
　　　・他のユーザー詳細情報の確認
　　
　　・登録ユーザー
　　　・ログイン・ログアウト・退会機能
　　　・パスワード再設定機能
　　　・朝活開始時刻を設定
　　　・打刻後は、0:00まで再打刻できないように制限する。（打刻ボタンの非表示など）
　　　・ユーザーからの意見で、必要があれば開始時間の制限を変更する。
　　　・マイページ
　　　・自分の学習開始時間の推移をグラフ化
　　　・自分のやること（閲覧・編集・削除・追加）出来るようにする
　　　・他ユーザーのお気に入り登録機能、
　　
　　・管理ユーザー
　　　・登録ユーザーの検索、一覧、詳細、編集
　　　・管理ユーザーの一覧、詳細、作成、編集、削除
　　
　　・その他(問い合わせなど)
　　　・問い合わせ機能
　　　・お知らせ
　　　・利用規約
　　　・プライバシーポリシー

## ■なぜこのサービスを作りたいのか？
　きっかけは、私自身が現在朝活をしており、活動開始のログをメモやTwitterのログに残しているのだが、せっかく朝早く起きて残したログを文面だけでなく、グラフのような形で可視化できるものが欲しいと思い考えました。
　開発でも現在、毎日欠かさず草を生やしつづけていて、画面上に少しづつ草が増やしていますが、その様子を見ているだけでも、コツコツ積み上げている実感を得られてモチベーションが上がるし、成長している実感を持てており、満足しながら取り組めています。また、他の受講生で同じく朝活開始ツイートを流しているのを見ると、私自身もモチベーションが高まり、より朝活に対して前向きな気持ちで取り組めているように感じます。
　なので、朝早く活動していることを可視化させて、私自身も朝活に対してのモチベーションをより多く味わいたい、朝活にチャレンジしてみたい人にも楽しみ感じてもらいたいと思いこのサービスを考えました、


## ■スケジュール
  1. 企画（アイデア企画・技術調査）：2/12〆切
  2. 設計（README作成・画面遷移図作成・ER図作成）：2/19 〆切
  3. 機能実装：2/19 - 3/19
  4. MVPリリース：3/19〆切
  5. 本リリース：4/1
