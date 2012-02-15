module Beintoo
  class Vgood
    RESOURCE = "vgood"

    ATTRIBUTES = %w{getRealURL showURL description descriptionSmall id imageUrl imageSmallUrl startdate enddate name bedollars discount VgoodPoiWrapper  whoAlsoConverted  categories isBanner contentType content rewardText shareURL uvext}

    ATTRIBUTES.each do |a|
      self.send("attr_accessor", a)
    end

    def initialize(params = {})
      params.each do |a,v|
        self.send("#{a}=", v)
      end
    end

    def to_s
      ATTRIBUTES.inject(''){|s,a| s << "#{a}: #{self.send(a).to_s}\n"}
    end

    def == (other)
      self.id == other.id
    end

##### VGood api wrapped methods see http://documentation.beintoo.com/home/api-docs/resources/vgood

    # return the vgoods owned by the current user not yet converted.
    def self.showbyuser(user = nil)
      raise Beintoo::ApiException, "Called Vgood.byuser without passing a user!" if user.nil?
      headers = Beintoo::build_headers
      result = Beintoo::get "#{RESOURCE}/show/byuser/#{user.id}", headers
      vgoods = []
      result.each do |vgood|
        vgoods << Beintoo::Vgood.new(vgood)
      end
      vgoods
    end

    # Get a list of POTENTIAL rewards for the user
    # Should return an array of Beintoo::Vgood objects
    def self.byuser(user = nil)
      raise Beintoo::ApiException, "Called Vgood.byuser without passing a user!" if user.nil?
      headers = Beintoo::build_headers
      result = Beintoo::get "#{RESOURCE}/byuser/#{user.id}", headers
      vgoods = []
      result[:vgoods].each do |vgood|
        vgoods << Beintoo::Vgood.new(vgood)
      end
      vgoods
    end

    # User can accept a given reward previously fetched with self.byuser
    def self.accept(user = nil, reward = nil)
      raise Beintoo::ApiException, "Called Vgood.accept_reward without passing a user!" if user.nil?
      raise Beintoo::ApiException, "Called Vgood.accept_reward without passing a reward!" if reward.nil?
      headers = Beintoo::build_headers
      if reward.is_a? Beintoo::Vgood
        result = Beintoo::get "#{RESOURCE}/accept/#{reward.id}/#{user.id}", headers
      else
        result = Beintoo::get "#{RESOURCE}/accept/#{reward}/#{user.id}", headers
      end
      # XXX WE SHOULD DETECT ERRORS HERE
      true
    end

    def self.byplayer(player = nil)
      raise Beintoo::ApiException, "Called Vgood.byplayer without passing a player!" if !player.logged_in?
      headers = Beintoo::build_headers
      result = Beintoo::get "#{RESOURCE}/byguid/#{player.guid}", headers
      vgoods = []
      result[:vgoods].each do |vgood|
        vgoods << Beintoo::Vgood.new(vgood)
      end
      vgoods
    end


    # Returns a vgood, this method act as Vgood.getByUser but providing player guid instead of userExt.
    def getVgoodByGuid
    end

    # return the friends of the given user
    def convert
    end

    # return the friends of the given user
    def sendAsGift
    end
  end
end
