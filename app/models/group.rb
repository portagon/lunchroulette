class Group < ApplicationRecord
  PERSONS_PER_GROUP = 4
  MIN_PERSONS_PER_GROUP = 3

  belongs_to :leader, class_name: 'User', optional: true
  has_many :lunches
  has_many :users, through: :lunches

  validates :date, :size, presence: true

  def self.create_all_groups!
    date = Date.today
    lunches = Lunch.on(date)
    groups_count = lunches.count / PERSONS_PER_GROUP
    groups_count += 1 if lunches.count % PERSONS_PER_GROUP >= MIN_PERSONS_PER_GROUP
    groups = (1..groups_count).map { Group.new(date: date, size: PERSONS_PER_GROUP) }
    assign_group_sizes(lunches, groups)
  end

  def self.assign_group_sizes(lunches, groups)
    rest_lunches = lunches.count % PERSONS_PER_GROUP

    unless rest_lunches == 0
      if rest_lunches >= MIN_PERSONS_PER_GROUP
        groups.last.size = rest_lunches # small group
      elsif rest_lunches < MIN_PERSONS_PER_GROUP && groups.count == 1
        groups.last.size = lunches.count # one group with all lunches
      elsif rest_lunches < MIN_PERSONS_PER_GROUP
        big_groups_count = lunches.count % PERSONS_PER_GROUP
        count = rest_lunches / big_groups_count + PERSONS_PER_GROUP
        groups.sample(big_groups_count).each { |group| group.size = count }
      end
    end

    send_groups(lunches, groups) # full groups
  end

  def self.send_groups(lunches, groups)
    groups.each do |group|
      remaining_lunches = lunches.where(group: nil)
      group.create_group!(remaining_lunches)
    end
  end

  def create_group!(remaining_lunches)
    save
    assign_lunches(remaining_lunches)
    update(leader: lunches.sample.user)
  end

  def assign_lunches(lunches)
    lunches.sample(size).map do |lunch|
      lunch.group = self
      lunch.save
    end
  end
end
