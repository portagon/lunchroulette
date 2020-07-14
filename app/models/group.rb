class Group < ApplicationRecord
  PERSONS_PER_GROUP = 4

  belongs_to :leader, class_name: 'User', optional: true
  has_many :lunches
  has_many :users, through: :lunches

  validates :date, presence: true

  def self.create_all_groups!
    date = Date.today
    lunches = Lunch.on(date)
    groups_count = lunches.count / PERSONS_PER_GROUP
    groups = (1..groups_count).map { Group.new(date: date) }
    assign_group_sizes(lunches, groups)
  end

  def create_group!(remaining_lunches)
    save
    assign_lunches(remaining_lunches)
    update(leader: lunches.sample.user)
  end

  private

  def assign_lunches(lunches)
    lunches.sample(4).map do |lunch|
      lunch.group = self
      lunch.save
    end
  end

  def self.assign_group_sizes(lunches, groups)
    # groups_with_5_count = lunches.count % PERSONS_PER_GROUP
    # groups_with_5 = groups.pop(groups_with_5_count)
    # groups_with_4 = groups
    groups.each do |group|
      remaining_lunches = lunches.where(group: nil)
      group.create_group!(remaining_lunches)
    end
  end
end
