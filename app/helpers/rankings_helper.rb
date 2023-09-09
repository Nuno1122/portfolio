module RankingsHelper
    # ランキングの背景スタイルを返す。ランキングの順位（rank）に応じて、
    # プライマリ色（'bg-primary-color'）の背景スタイルを返すか、
    # セカンダリ色（'bg-secondary-color'）の背景スタイルを返す。( 上位3位までプライマリ色、それ以降はセカンダリ色)
    def ranking_background_style(rank)
      rank <= RankingsController::TOP_RANK ? 'flex flex-col bg-primary-color rounded-lg p-4 shadow-md mb-4' : 'flex flex-col bg-secondary-color rounded-lg p-4 shadow-md mb-4'
    end
  
    # ランキングのテキストスタイルを返す。ランキングの順位（rank）に対応するスタイルを
    # RankingsController::RANK_TEXT_STYLESから取得し、存在しなければデフォルトのスタイルを返す。
    def rank_text_style(rank)
      RankingsController::RANK_TEXT_STYLES.fetch(rank, RankingsController::RANK_TEXT_STYLES[:default])
    end
  end
  