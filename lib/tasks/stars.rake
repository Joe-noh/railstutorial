namespace :stars do
  desc "今日が大安ならスターを選びます"
  task elect_if_taian: :environment do
    today = Time.zone.today

    if Rokuyou.new(today).taian?
      Rake::Task['stars:elect'].invoke
    end
  end

  desc "無条件にスターを選びます"
  task elect: :environment do
    today = Time.zone.today
    StarElection.new(today).elect!
  end
end
