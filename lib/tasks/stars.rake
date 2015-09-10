namespace :stars do
  desc "TODO"
  task election: :environment do
    StarElection.new.elect
  end
end
