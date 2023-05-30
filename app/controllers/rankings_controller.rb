class RankingsController < ApplicationController
  TOP_RANK_COUNT = 20 # ランキングに表示する上位の数
  TOP_RANK = 3 # ランキング上位（ゴールド、シルバー、ブロンズ）の閾値
  
  # ランキング上位のテキストスタイルを定義する定数
  RANK_TEXT_STYLES = {
    1 => 'text-2xl text-achieved-gold', # 1位のスタイル
    2 => 'text-xl text-achieved-silver', # 2位のスタイル
    3 => 'text-l text-achieved-bronze', # 3位のスタイル
    default: 'text-m' # それ以外のスタイル
  }.freeze

  # ランキング上位の右側テキストスタイルを定義する定数
  RANK_TEXT_RIGHT_STYLES = {
    1 => 'text-xl text-achieved-gold',
    2 => 'text-l text-achieved-silver',
    3 => 'text-l text-achieved-bronze',
    default: 'text-m'
  }.freeze

  def index
    # 年の選択肢を生成（今年から過去1年分）
    @years = (Time.current.year - 1..Time.current.year).to_a.reverse
    # 月の選択肢を生成（1月～12月）
    @months = (1..12).to_a
    # 選択された年を取得（指定がなければ今年）
    @selected_year = params[:year] || Time.current.year
    # 選択された月を取得（指定がなければ今月）
    @selected_month = params[:month] || Time.current.month
    # ランキングデータを準備
    @ranking = prepare_rankings(@selected_year, @selected_month)
  end
  
  private

  def prepare_rankings(year, month)
    # 月間達成ランキングを取得し、上位20人を抽出
    achievements_ranking = MonthlyAchievement.achievements_ranking(year, month).first(TOP_RANK_COUNT)
    # ランキング内のユーザーIDを抽出
    user_ids = achievements_ranking.map(&:first)
    # ユーザーIDに該当するユーザー情報を取得し、ユーザーIDをキーにしたハッシュに変換
    users = User.where(id: user_ids).index_by(&:id)
    
    # ランキングのユーザーIDをユーザーオブジェクトに変換
    rankings_with_user_objects = achievements_ranking.map do |user_id, achieved_count|
      [users[user_id], achieved_count]
    end
    
    # ランキングを計算
    calculate_ranking(rankings_with_user_objects)
  end

  def calculate_ranking(achieved_rankings)
    previous_count = nil # 前のユーザー
    rank = 0 # 現在のランクを初期化（0からスタート）

    # achieved_rankings（ユーザーとその達成数の配列）をループ処理
    achieved_rankings.map do |user, achieved_count|
      # 前のユーザーの達成数と現在のユーザーの達成数が異なる場合、ランクを1つ増やす
      # 同じ達成数のユーザーが連続する場合、ランクは変わらない（同順となる）
      rank += 1 if previous_count != achieved_count
      # 現在のユーザーの達成数を保存して次のループへ
      previous_count = achieved_count
      # ランキング情報をハッシュ形式で返す（ユーザー、ランク、達成数）
      { user: user, rank: rank, achieved_count: achieved_count }
    end
  end
end
