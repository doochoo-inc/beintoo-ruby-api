module Beintoo
  module ModelAdditions
    # field is the name of the field used for guid i.e. :id
    def acts_as_beintoo_user(params = {})

      par = {guid_field: :id, email_field: :email, name_field: :name, nickname_field: :nickname}.merge(params)

      define_method 'beintoo_player' do
        if @beintoo_player.nil?
          @beintoo_player = Beintoo::Player.new({guid: self.send(par[:guid_field])})
          @beintoo_player.login
        end
        @beintoo_player
      end

      define_method 'beintoo_user' do
        begin
          if @beintoo_user.nil?
            @beintoo_user = beintoo_player.user({
              email: self.send(par[:email_field]),
              name: self.send(par[:name_field]),
              nickname: self.send(par[:nickname_field]),
              sendGreetingsEmail: false
            })
            @beintoo_user.create
          end
          @beintoo_user
        rescue Beintoo::UserAlreadyRegisteredException => e
          @beintoo_user = nil
          return Beintoo.get_connect_url self.send(par[:guid_field])
        end
      end

      define_method 'beintoo_get_potential_rewards' do
        @beintoo_user.potential_rewards
      end

      define_method 'beintoo_accept_reward' do |reward|
        @beintoo_user.accept_reward(reward)
      end

      define_method 'beintoo_list_rewards' do
        @beintoo_user.list_rewards
      end

    end
  end
end