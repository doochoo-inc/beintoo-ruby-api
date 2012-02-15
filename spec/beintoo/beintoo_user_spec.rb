require 'spec_helper'

describe 'BeintooUser' do
  before :each do
    set_testing_data
  end

  it "Should generate a Beintoo::User for a Beintoo::Player" do
    player = Beintoo::Player.new guid: "test#{rand(300)}"
    player.login
    user = player.user.create email: "foo_bar+#{rand(300)}@example.com", name: "Foo Bar", nickname: "foo_bar"
    if Beintoo.debug
      puts player.user.get_user_params
      puts user.inspect
    end
    user.id.should_not be nil
  end

  it "Should generate a reward for a Beintoo::User" do
    player = Beintoo::Player.new guid: "test#{rand(300)}"
    player.login
    user = player.user.create email: "foo_bar+#{rand(300)}@example.com", name: "Foo Bar", nickname: "foo_bar"
    user.potential_rewards
    user.list_rewards
  end

end