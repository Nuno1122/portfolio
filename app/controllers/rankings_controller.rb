class RankingsController < ApplicationController
  def index
    year = params[:year] || Time.current.year
    month = params[:month] || Time.current.month
    @ranking = MonthlyAchievement.achievements_ranking(year, month).first(20)
  end
  
end
