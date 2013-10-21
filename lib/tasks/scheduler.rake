namespace :clean do
  task :guests => :environment do
    guests = User.where(guest: true).where("updated_at < ?", 1.week.ago)
    guests.destroy_all
  end

  task :events => :environment do
    events = Event.where(state: 0).where("updated_at < ?", 1.week.ago)
    events.delete_all
  end

  task :cancelled_events => :environment do
    events = Event.where(state: 4)
    events.delete_all
  end

  desc "Clean out old guest user records and associated events"
  task all: [:events, :guests]
end