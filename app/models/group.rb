class Group < ApplicationRecord
  PERSONS_PER_GROUP = 4
  MIN_PERSONS_PER_GROUP = 3
  RESTAURANTS = [
    'Saopres', 'Pho Ngon', 'Lam Freres', 'Good Guys', 'Der Fette Bulle', 'eatDoori', 'Yuyumi', 'trinitii', 'Mr. Lee', 'Africa Queen', 'Merkez Döner', 'Toh Tong', 'Vita Vera', 'MoschMosch', "L'Osteria", 'Falafel 1818', 'Seoulfood', 'Sarajevo'
  ].freeze

  belongs_to :leader, class_name: 'User', optional: true
  has_many :lunches
  has_many :users, through: :lunches

  validates :date, :size, presence: true

  scope :on, -> (date) { where(date: date) }

  def self.create_all_groups!(date: Date.tomorrow)
    puts "\n\nOwn output here...\n"
    puts "Rails.env: #{Rails.env}\n"
    puts "lunches: #{Lunch.on(date)}"
    puts "Lunches count: #{Lunch.on(date).count}\n"

    vars = initialize_groups_and_find_lunches(date)
    puts "vars[:lunches]: #{vars[:lunches]}"
    puts "vars[:groups]: #{vars[:groups]}\n"

    return if vars[:lunches].to_a.empty? # escape if no lunch is registered for the day

    groups = assign_group_sizes(vars[:lunches], vars[:groups])
    save_groups(vars[:lunches], groups)

    puts "groups: #{Group.on(date)}"
    puts "groups count: #{Group.on(date).to_a}"
    puts "lunches: #{Group.on(date).first.lunches}"
    puts "lunches count: #{Group.on(date).first.lunches.count}"
    puts "user: #{Group.on(date).first.lunches.first.user}\n"

    puts "Now all Lunches get confirmed...\n"
    Lunch.on(date).map(&:confirm!) # confirmation mail
    puts "Lunches are done confirming!"

    puts "\n\nOwn output ends here!\n\n"
  end

  def self.initialize_groups_and_find_lunches(date)
    lunches = Lunch.on(date)
    return { lunches: lunches } if lunches.to_a.empty? # escape if no lunch is registered for the day

    groups_count = lunches.count < MIN_PERSONS_PER_GROUP ? 1 : lunches.count / PERSONS_PER_GROUP
    groups_count += 1 if lunches.count % PERSONS_PER_GROUP >= MIN_PERSONS_PER_GROUP
    groups = (1..groups_count).map { Group.new(date: date, size: PERSONS_PER_GROUP) }
    { groups: groups, lunches: lunches }
  end

  def self.assign_group_sizes(lunches, groups)
    rest_lunches = lunches.count % PERSONS_PER_GROUP
    return groups if rest_lunches.zero?

    if rest_lunches >= MIN_PERSONS_PER_GROUP
      groups.last.size = rest_lunches # small group
    elsif rest_lunches < MIN_PERSONS_PER_GROUP && groups.count == 1
      groups.last.size = lunches.count # one group with all lunches
    elsif rest_lunches < MIN_PERSONS_PER_GROUP
      return handle_big_groups(lunches, rest_lunches, groups)
    end

    groups # all groups incl. full ones
  end

  def self.handle_big_groups(lunches, rest_lunches, groups)
    big_groups_count = lunches.count % PERSONS_PER_GROUP
    count = rest_lunches / big_groups_count + PERSONS_PER_GROUP
    groups.sample(big_groups_count).each { |group| group.size = count }

    groups
  end

  def self.save_groups(lunches, groups)
    groups.each do |group|
      remaining_lunches = lunches.where(group: nil)
      group.create_group!(remaining_lunches)
    end
  end

  def create_group!(remaining_lunches)
    save
    assign_lunches(remaining_lunches)
    update(leader: lunches.sample.user)
    update(restaurant: RESTAURANTS.sample)
  end

  def assign_lunches(lunches)
    lunches.sample(size).map do |lunch|
      lunch.update(group: self)
    end
  end
end
