require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @persons_per_group = Group::PERSONS_PER_GROUP
    @min_persons = Group::MIN_PERSONS_PER_GROUP
  end

  def single_test_setup(user_count)
    count = 1
    user_count.times do
      User.create(email: "#{count}@portagon.com")
      count += 1
    end

    User.all.each { |u| Lunch.create(user: u, date: Date.tomorrow) }
  end

  def basic_assertions
    users_in_groups = Group.all.map { |g| g.users.map(&:id) }.flatten
    assert_equal users_in_groups.count, users_in_groups.uniq.count
    assert_equal Lunch.count, users_in_groups.count
    assert(Lunch.all.all? { |l| l.group.present? })
  end

  test 'No lunches registered, no groups created' do
    single_test_setup(@persons_per_group * 4)
    Lunch.destroy_all
    Group.create_all_groups!

    assert_equal 0, Lunch.count
    assert_equal 0, Group.count
  end

  test 'Lunch.count % PERSONS_PER_GROUP == 0 get assigned to similar sized groups' do
    single_test_setup(@persons_per_group * 4)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    full_groups = group_counts.count(@persons_per_group)
    assert_equal 4, full_groups

    Group.all.each do |g|
      assert_equal @persons_per_group, g.lunches.count
    end

    basic_assertions
  end

  # TODO: make this test past for different constants (e.g. 8 and 6)
  test 'Lunch.count % PERSONS_PER_GROUP > 0 but smaller MIN_PERSONS_PER_GROUP get assigned correctly' do
    persons = @persons_per_group * 3 + @min_persons - 1
    single_test_setup(persons)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }
    rest_persons = persons % @persons_per_group
    added_persons = Group.count / rest_persons

    full_groups = group_counts.count(@persons_per_group)
    big_groups = group_counts.count(@persons_per_group + added_persons)

    assert_equal rest_persons, big_groups
    assert_equal Group.count - big_groups, full_groups

    basic_assertions
  end

  test 'Lunch.count % PERSONS_PER_GROUP > 0 but smaller MIN_PERSONS_PER_GROUP get assigned correctly when Group.count == 1' do
    persons = @persons_per_group + @min_persons - 1
    single_test_setup(persons)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }
    rest_persons = persons % @persons_per_group
    added_persons = Group.count / rest_persons

    full_groups = group_counts.count(@persons_per_group)
    big_groups = group_counts.count(@persons_per_group + rest_persons)

    assert_equal 1, big_groups
    assert_equal 0, full_groups

    basic_assertions
  end

  test 'Lunch.count % PERSONS_PER_GROUP > 0 but >= MIN_PERSONS_PER_GROUP to X full groups and one small' do
    persons = @persons_per_group + @min_persons
    single_test_setup(persons)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    full_groups = group_counts.count(@persons_per_group)
    small_groups = group_counts.count(@min_persons)

    assert_equal 1, small_groups
    assert_equal Group.count - small_groups, full_groups

    basic_assertions
  end

  test 'PERSONS_PER_GROUP > Lunch.count >= MIN_PERSONS_PER_GROUP get assigned to 1 group' do
    persons = @min_persons
    single_test_setup(persons)
    Group.create_all_groups!

    group_counts = Group.all.map { |g| g.lunches.count }

    small_group = group_counts.count(persons)
    assert_equal 1, small_group

    basic_assertions
  end

  test 'Lunch.count < MIN_PERSONS_PER_GROUP get assigned to 1 group' do
    persons = @min_persons - 1
    single_test_setup(persons)
    Group.create_all_groups!

    assert_equal 1, Group.count

    basic_assertions
  end
end
