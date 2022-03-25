require 'test_helper'

class LunchTest < ActiveSupport::TestCase
  setup do
    @date = Date.today.next_occurring(:friday)
    @group = Group.create(date: @date, size: 3)
    @user = User.create(email: 'test@portagon.net')
    travel_to Date.today.next_occurring(:monday)
    @lunch = Lunch.create(status: 'confirmed', date: @date, user: @user, group: @group)
  end

  test 'Lunches can be assigned to users and groups' do
    travel_to Date.today.next_occurring(:friday)
    assert_not_nil(@user.lunches.on(@date).first.group.lunches.any?, 'Not Working')
  end
end
