require 'test_helper'

class LunchTest < ActiveSupport::TestCase
  setup do
    @user = users(:user_one)
    @group = groups(:group_one)
    travel_to Date.today.next_occurring(:tuesday)
    @lunch = Lunch.create(status: "confirmed", date: Date.today.next_occurring(:thursday), user: @user, group: @group)

  end
  test "Lunches can be assigned to users and groups" do
    travel_to Date.today.next_occurring(:thursday)
    assert_not_nil(@user.lunches.on(@date).first.group.lunches.any? , "Not Working")
    p @user.lunches.on(@date).first.group.lunches.first
  end
end
