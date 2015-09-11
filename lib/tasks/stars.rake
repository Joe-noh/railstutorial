namespace :stars do
  desc "スターを選びます"
  task election: :environment do
    today = Time.zone.today

    if Rokuyou.new(today).taian?
      StarElection.new(today).elect!
    end
  end
end
