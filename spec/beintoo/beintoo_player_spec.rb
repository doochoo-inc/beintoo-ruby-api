require 'spec_helper'

describe 'BeintooPlayer' do
  before :each do
    set_testing_data
  end

  it "Should login/logout Player" do
    player = Beintoo::Player.new
    player.respond_to?(:logout).should be true
    player.login
    player.logged_in?.should be true
    if Beintoo.debug
      puts player.guid
    end
    player.logout
    player.logged_in?.should be false
  end

  it "Should get player with guid" do
    player = Beintoo::Player.new guid: "test"
    player.login
    player.get_player
  end

  it "Should have score" do
    player = Beintoo::Player.new guid: "test"
    player.login
    player.respond_to?(:submit_score).should be true
    player.submit_score(40)
    if Beintoo.debug
      puts player.get_player
    end
    player.submit_score(30)
    if Beintoo.debug
      puts player.get_player
    end
    player.submit_score(50)
    if Beintoo.debug
      puts player.get_player
    end
  end

  it "Should assign a reward to the Beintoo::Player" do
    player = Beintoo::Player.new guid: "BeintooGemTest_#{rand(300)}"
    player.login
    player.assign_reward
  end
end