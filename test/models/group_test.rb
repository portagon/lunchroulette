require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    count = 1
    16.times do
      User.create(email: "#{count}@crowddesk.de")
      count += 1
    end

    User.all.each { |u| Lunch.create(user: u, date: Date.today) }
  end

  test '16 customers get assigned to a group' do
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    groups_with4 = group_counts.count(4)
    assert_equal 4, groups_with4

    Group.all.each do |g|
      assert_equal 4, g.lunches.count
    end

    users_in_groups = Group.all.map { |g| g.users.map(&:id) }.flatten
    assert_equal users_in_groups.count, users_in_groups.uniq.count
    assert_equal Lunch.count, users_in_groups.count
    assert(Lunch.all.all? { |l| l.group.present? })
  end
end
