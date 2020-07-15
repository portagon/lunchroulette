class LunchesController < ApplicationController
  def index
    @date = Date.parse(params[:date]) rescue Date.today
    @same_day_ok = Time.now < Date.today.midday - 1.hour
    @can_register = @current_user.lunches.new(date: @date).valid? && @same_day_ok
    @other_lunches = Lunch.on(@date)
  end

  def create
    @same_day_ok = Time.now < Date.today.midday - 1.hour
    date = Date.parse(params[:date])
    @lunch = @current_user.lunches.create(date: date)

    register_same_day if @same_day_ok && date == Date.today

    redirect_to root_path(date: date)
  end

  def destroy
    lunch = @current_user.lunches.find(params[:id])
    date = lunch.date

    lunch.destroy

    flash[:notice] = 'Your lunch was canceled.'
    redirect_to root_path(date: date)
  end

  private

  def register_same_day
    return Group.create_all_groups!(date: Date.today) if Group.on(Date.today).count.zero?

    @lunch.add_single_to_group
    @lunch.group.lunches.each do |lunch|
      UserMailer.lunch_confirmed_mail(lunch).deliver_later
    end
  end
end
