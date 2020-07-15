require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def single_test_setup(user_count)
    count = 1
    user_count.times do
      User.create(email: "#{count}@crowddesk.de")
      count += 1
    end

    User.all.each { |u| Lunch.create(user: u, date: Date.today) }
  end

  def basic_assertions
    users_in_groups = Group.all.map { |g| g.users.map(&:id) }.flatten
    assert_equal users_in_groups.count, users_in_groups.uniq.count
    assert_equal Lunch.count, users_in_groups.count
    assert(Lunch.all.all? { |l| l.group.present? })
  end

  test '16 users get assigned to a group' do
    single_test_setup(16)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    groups_with4 = group_counts.count(4)
    assert_equal 4, groups_with4

    Group.all.each do |g|
      assert_equal 4, g.lunches.count
    end

    basic_assertions
  end

  test '13 users get assigned to 3 groups' do
    single_test_setup(13)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    groups_with4 = group_counts.count(4)
    groups_with5 = group_counts.count(5)
    groups_with6 = group_counts.count(6)
    assert_equal 2, groups_with4
    assert_equal 1, groups_with5
    assert_equal 0, groups_with6

    basic_assertions
  end

  test '14 users get assigned to 3 groups' do
    single_test_setup(14)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    groups_with4 = group_counts.count(4)
    groups_with5 = group_counts.count(5)
    groups_with6 = group_counts.count(6)
    assert_equal 1, groups_with4
    assert_equal 2, groups_with5
    assert_equal 0, groups_with6

    basic_assertions
  end

  test '6 users get assigned to 1 group' do
    single_test_setup(6)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    groups_with4 = group_counts.count(4)
    groups_with5 = group_counts.count(5)
    groups_with6 = group_counts.count(6)
    assert_equal 0, groups_with4
    assert_equal 0, groups_with5
    assert_equal 1, groups_with6

    basic_assertions
  end

  test '11 users get assigned to 3 groups' do
    single_test_setup(11)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    groups_with3 = group_counts.count(3)
    groups_with4 = group_counts.count(4)
    groups_with5 = group_counts.count(5)
    groups_with6 = group_counts.count(6)
    assert_equal 1, groups_with3
    assert_equal 2, groups_with4
    assert_equal 0, groups_with5
    assert_equal 0, groups_with6

    basic_assertions
  end
end
