require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  def setup
    @user1 = User.create(email: 'test@crowddesk.de')
    @user2 = User.create(email: 'test2@crowddesk.de')

    @lunch1 = Lunch.create(user: @user1, date: Date.tomorrow)
    @lunch2 = Lunch.create(user: @user2, date: Date.tomorrow)

    ActionMailer::Base.deliveries.clear
  end

  def teardown
    ActionMailer::Base.deliveries.clear
  end

  test '#login_mail' do
    email = UserMailer.login_mail(@user1)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [@user1.email], email.to
    assert email.body.to_s.match(%r{users\/.*\/login})
  end

  test '#lunch_confirmed_mail' do
    Group.create_all_groups!
    lunch = Lunch.first

    email = UserMailer.lunch_confirmed_mail(lunch)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [@user1.email], email.to
    assert email.body.to_s.match(%r{users\/.*\/login})
  end
end
