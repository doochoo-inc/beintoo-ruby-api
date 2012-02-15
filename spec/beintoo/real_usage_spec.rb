require 'spec_helper'

describe 'BeintooUsage' do
  before :each do
    set_real_case_data
  end

  it "should create a player" do
    player = Beintoo::Player.new guid: "1"
    player.login
    puts player.submit_score(0, nil, 0)
    sleep 1
    puts player.get_player
    sleep 1
    binding.pry
    player.last_score.should eq 0.0
    player.submit_score(30)
    sleep 1
    player.last_score.should eq 30.0
    player.submit_score(40)
    sleep 1
    player.last_score.should eq 70.0
  end
end
