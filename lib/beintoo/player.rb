module Beintoo
  class Player
    RESOURCE = "player"
    attr_accessor :guid, :logged_in, :b_user, :score

    def initialize(params = {})
      self.guid = params[:guid]
      self
    end

    def user(params = {})
      raise Beintoo::ApiException, "No guid set when creating new Beintoo::User" if guid.nil?
      if b_user.nil?
        self.b_user = Beintoo::User.new params.merge(guid: guid)
      end
      b_user
    end

    def login(_guid = nil, publicname = nil)
      self.guid = _guid unless _guid.nil?
      headers = {}
      headers[:guid] = guid unless guid.nil?
      headers = Beintoo::build_headers headers

      params_get = {}
      params_get[:language] = 1
      params_get[:publicname] = publicname unless publicname.nil?
      result = Beintoo::get "#{RESOURCE}/login", headers, params_get
      self.guid = result["guid"]
      self.logged_in = true
      if result.has_key? "user"
        self.b_user = Beintoo::User.new result["user"].merge(guid: guid)
        self.b_user.created = true
      end
    end

    def logged_in?
      !!logged_in
    end

    def logout
      return true if !logged_in?
      headers = {}
      headers[:guid] = guid
      headers = Beintoo::build_headers headers

      result = Beintoo::get "#{RESOURCE}/logout", headers
      self.logged_in = false
    end

    def get_player(_guid = nil)
      self.guid = _guid unless _guid.nil?
      raise Beintoo::ApiException, "No guid setted when calling get_player" if guid.nil?
      headers = Beintoo::build_headers
      result = Beintoo::get "#{RESOURCE}/byguid/#{guid}", headers
      if result.has_key? :playerScore
        self.score = result[:playerScore]
      end
    end

    def submit_score(score, code_id = nil, balance = nil)
      raise Beintoo::ApiException, "User not logged in when trying to submit score" unless logged_in?
      headers = {
        guid:   guid,
      }
      headers[:codeID] = code_id unless code_id.nil?
      headers = Beintoo::build_headers headers
      body = {lastScore: score}
      body[:balance] = balance unless balance.nil?
      if Beintoo.debug
        Beintoo.log "Submitting score of #{score} for player with guid #{guid}"
        Beintoo.log body.inspect
      end
      result = Beintoo::get "#{RESOURCE}/submitscore/", headers, body
      if result.has_key? :playerScore
        self.score = result[:playerScore]
      end
      if result[:message] == "OK" && result[:messageID] == 0
        true
      else
        false
      end
    end

    def last_score(contest = :default)
      score[contest][:lastscore] rescue nil
    end

    def best_score(contest = :default)
      score[contest][:bestscore] rescue nil
    end

    def balance(contest = :default)
      score[contest][:balance] rescue nil
    end

    def assign_reward
      Beintoo::Vgood.byplayer(self)
    end

  end
end
