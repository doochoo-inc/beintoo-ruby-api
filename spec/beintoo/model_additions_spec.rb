require 'spec_helper'

class User < SuperModel::Base
  include SuperModel::RandomID
  extend Beintoo::ModelAdditions
  acts_as_beintoo_user guid_field: :id, email_field: :email, name_field: :name, nickname_field: :nickname
end

describe Beintoo::ModelAdditions do
  before :each do
    set_testing_data
  end

  it "should create a player with a user" do
    u = User.create email: "foo_bar+#{rand(1000)}@example.com", name: "Foo Bar", nickname: "foo_bar"
    u.beintoo_player.class.should be Beintoo::Player
    u.beintoo_user.class.should be Beintoo::User
    u.beintoo_user.email.should match(/foo_bar/)
  end

  it "should retrieve a player with his user" do
    # if player has already a user we should fetch him from beintoo and istantiate it locally
    u = User.create id: 1234567, email: "foobar@example.com", name: "Foo Bar", nickname: "foo_bar"
    u.beintoo_player.class.should be Beintoo::Player
    u.beintoo_user.class.should be Beintoo::User
    u.beintoo_user.name.should match(/Foo/)
    u.beintoo_user.id.should_not be nil

    u.respond_to?(:beintoo_get_potential_rewards).should be true
    rews = u.beintoo_get_potential_rewards

    u.beintoo_list_rewards.should_not include rews.first

    u.respond_to?(:beintoo_accept_reward).should be true
    u.beintoo_accept_reward(rews.first).should be true # XXX see XXX on vgood.rb

    u.respond_to?(:beintoo_list_rewards).should be true
    u.beintoo_list_rewards.should include rews.first
  end

  it "should return a beintoo connect url when creating a user with an existing email" do
    u = User.create id: 22222, email: "foobar@example.com", name: "Mario", nickname: "Rossi"
    u.beintoo_player.class.should be Beintoo::Player
    bu = u.beintoo_user
    bu.class.should be String
    puts bu
  end

end