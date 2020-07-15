class Group < ApplicationRecord
  PERSONS_PER_GROUP = 4
  MIN_PERSONS_PER_GROUP = 3

  belongs_to :leader, class_name: 'User', optional: true
  has_many :lunches
  has_many :users, through: :lunches

  validates :date, presence: true

  def self.create_all_groups!
    date = Date.today
    lunches = Lunch.on(date)
    groups_count = lunches.count / PERSONS_PER_GROUP
    groups_count += 1 if lunches.count % PERSONS_PER_GROUP >= MIN_PERSONS_PER_GROUP
    groups = (1..groups_count).map { Group.new(date: date) }
    assign_group_sizes(lunches, groups)
  end

  def create_group!(remaining_lunches, count)
    save
    assign_lunches(remaining_lunches, count)
    update(leader: lunches.sample.user)
  end

  private

  def assign_lunches(lunches, count)
    lunches.sample(count).map do |lunch|
      lunch.group = self
      lunch.save
    end
  end

  def self.assign_group_sizes(lunches, groups)
    if lunches.count == 6
      groups_with6 = groups
      send_groups(lunches, groups_with6, 6)
    elsif lunches.count % PERSONS_PER_GROUP >= MIN_PERSONS_PER_GROUP
      groups_with3 = [groups.pop]
      groups_with4 = groups

      send_groups(lunches, groups_with3, 3)
      send_groups(lunches, groups_with4, 4)
    else
      groups_with5_count = lunches.count % PERSONS_PER_GROUP
      groups_with5 = groups.pop(groups_with5_count)
      groups_with4 = groups

      send_groups(lunches, groups_with5, 5)
      send_groups(lunches, groups_with4, 4)
    end
  end

  def self.send_groups(lunches, groups, count)
    groups.each do |group|
      remaining_lunches = lunches.where(group: nil)
      group.create_group!(remaining_lunches, count)
    end
  end
end
