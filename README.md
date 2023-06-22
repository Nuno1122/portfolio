# サービス名：おはログ！！🌞
<img width="787" alt="スクリーンショット 2023-06-22 13 56 26" src="https://github.com/Nuno1122/portfolio/assets/110162517/2ba1aa85-3114-4d41-8e8f-0f551072fb9c">

## [おはログ!!🌞](https://morning-activity.fly.dev/)


## ■ サービス概要 
朝活開始時刻を手軽に記録し見える化することで、毎日の継続を楽しく支える朝活サポートサービスです

## ■開発した背景
プログラミング学習を始めてから、朝活を継続して行うようにしております。
朝活は学習意欲の向上や生活リズムの整備に効果的だと実感しているため、より多くの人々に朝活を取り入れてもらいたいと思い、
朝活を促進するアプリを開発しようと考えました。また、朝活を行うだけでなく、継続して行えるようにできるものを作成したいと感じたため、
朝活のログを楽しく記録できるアプリとして「おはログ‼︎」というサービスを作成しました。

## ■メインのターゲットユーザー
- アサカツに興味がある人
- 朝活を最近始めて、継続させたい人

## ■ユーザーが抱える課題と解決方法
### 課題1:1人で朝活が続かない
- 仮説：朝活開始の際にメッセージを入力・共有することで、コミュニティ感覚での利用が可能になるのではないか
- 解決方法：朝活開始の際に朝活メッセージを投稿、一覧で確認できるようにすることで、簡単に他のユーザーへの朝活開始メッセージの共有や状況確認を行うことができる。
また、ゲーム要素として、朝活の成功回数をランキング化させることでモチベーション向上につなげる。
### 課題2:課題2: 朝活の開始時刻を毎回記録する必要があるが記録が面倒になりがち。
- 仮説：朝活開始時刻を一つのボタンで簡単に記録できる機能を提供することで、記録する手間をなくし、面倒さが軽減される
- 解決方法：朝活開始の打刻ボタンを提供する。これにより、ユーザーは自分の朝活の開始時刻を一瞬で記録し、正確に確認することができる。
### 課題3：朝活の目標開始時刻までにどれだけ継続的に開始できているか、比較したいが、これを手動で行うのは手間がかかる。
- 仮説：目標開始時刻と実際の開始時刻を自動的に比較し、評価する機能を提供することで、ユーザーは簡単に確認を行うことができる。
- 解決方法：システムが目標開始時刻と実際の開始時刻を比較し、ユーザーが目標時間内に開始できたかどうかを判定する。
また、カレンダーに成功可否を時刻と合わせて色別で表示させることで、直感的にユーザーは成功確認を行うことができる。


## ■実装機能
- ユーザー登録機能（名前・パスワード・メールアドレス・Twitter認証）
- ログイン・ログアウト機能
- 目標開始時刻の設定
- 開始のメッセージ作成と投稿(朝活を始める際のメッセージを作成し、開始の意気込みや取り組みを共有する)
- 朝活開始打刻 (朝活を始めた瞬間を記録し、後から追跡する)
- 目標時間内に開始できたかのカウント(目標開始時刻に対する自分の朝活開始時刻をカウントし、後から見返す)
- 打刻するページに、学習開始した時刻をカレンダーに表示させる	
- 投稿内容に「いいね」・「コメント」・「編集機能」
- ランキング機能
- 「利用規約」、「問い合わせ」、「プライバシーポリシー」作成

## ■今後の追加予定機能
- テストコードの作成
- 打刻するページに、自分の投稿履歴を見れるようにする
- LINE連携で就寝時刻前に通知が来るようにする。	
- LINE連携で就寝打刻を記録できるようにする	
- マイページ(ユーザー詳細ページ)作成
- 退会機能
		
## ■使用技術

**バックエンド
- ruby 3.1.3
- Ruby on Rails 7.0.4

** 主要ライブラリ
- importmap-rails
- turbo-rails
- stimulus-rails
- tailwindcss-rails
- rails-i18n
- annotate
- dotenv-rails
- omniauth-twitter
- sorcery
- byebug
- Rspec(テスト)
- RuboCop(リントチェック)
- kaminari(ページネーション)
- simple_calendar

**フロントエンド
- HTML/SCSS/JavaScript
- CSSフレームワーク
	- Tailwind CSS
	- daisyUI

**インフラ
- Fly.io
- PostgreSQL（データベース）

**ツール
- Googleアナリティクス

## 画面遷移図
https://www.figma.com/file/AZOsDuJ7keBIihRfMxLWE0/%E6%9C%9D%E6%B4%BB%E3%82%A2%E3%83%97%E3%83%AA%EF%BC%88%E4%BB%AE%EF%BC%89?node-id=0%3A1&t=DHOp2uIPpBFy4pT9-1

## ER図
https://drive.google.com/file/d/1SIZjWR66RoF40pZJffNIQgrD504SYaPZ/view?usp=sharing
<img width="547" alt="スクリーンショット 2023-06-22 13 59 10" src="https://github.com/Nuno1122/portfolio/assets/110162517/9515b8d1-822a-4ee0-9ed8-90b5f07226e8">
