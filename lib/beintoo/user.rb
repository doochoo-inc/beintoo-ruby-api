module Beintoo
  class User
    RESOURCE = "user"
    ATTRIBUTES = [:email, :address, :country, :gender, :nickname, :name, :password, :sendGreetingsEmail, :guid, :id, :userimg, :usersmallimg, :isverified, :lastupdate, :level, :bedollars, :bescore, :userExt]

    ATTRIBUTES.each do |a|
      self.send("attr_accessor", a)
    end

    attr_accessor :created

    def initialize(params = {})
      set_data params
    end

    def create(params = {})
      set_data params
      return self if created?
      if valid?
        headers = {
          guid: guid
        }
        headers = Beintoo::build_headers headers
        result = Beintoo::post "#{RESOURCE}/set", headers, get_user_params
        set_data result
        self.created = true
        self
      else
        false
      end
    end

    def created?
      created
    end

    def valid?
      !email.nil? && !guid.nil?
    end

    def to_hash
      h = {}
      ATTRIBUTES.each do |a|
        h[a] = self.send(a)
      end
      h
    end

##### rewards methods

    # Get a list of POTENTIAL rewards for the user
    def potential_rewards
      Beintoo::Vgood.byuser(self)
    end

    # User can accept a given reward previously fetched with self.byuser
    def accept_reward(reward)
      Beintoo::Vgood.accept(self, reward)
    end

    # return the vgoods owned by the current user not yet converted.
    def list_rewards
      Beintoo::Vgood.showbyuser(self)
    end


##### private
    def set_data(params = {})
      params = params.with_indifferent_access
      ATTRIBUTES.each do |at|
        self.send("#{at}=", params[at]) unless params[at].nil?
      end
      get_user_params
    end

    def get_user_params
      params = {}
      ATTRIBUTES.each do |at|
        params[at] = self.send("#{at}") unless self.send(at).nil?
      end
      params
    end
  end
end