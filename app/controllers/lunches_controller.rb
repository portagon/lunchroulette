class LunchesController < ApplicationController
  def index
    @date = Date.parse(params[:date]) rescue Date.today
    @can_register = @current_user.lunches.new(date: @date).valid? && @date.future?
    @other_lunches = Lunch.on(@date).where.not(user: @current_user)
  end

  def create
    date = Date.parse(params[:date])
    @current_user.lunches.create(date: date)

    redirect_to lunches_path(date: date)
  end
end
