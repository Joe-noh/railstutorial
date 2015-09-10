namespace :stars do
  desc "スターを選びます"
  task election: :environment do
    today = Date.today

    if Rokuyou.new(today).taian?
      StarElection.new(today).elect!
    end
  end
end
