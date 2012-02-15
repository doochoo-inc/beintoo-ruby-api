require "beintoo/version"
require "beintoo/player"
require "beintoo/user"
require "beintoo/vgood"
require "beintoo/api_exception"
require "beintoo/model_additions"
require "beintoo/railtie" if defined? Rails
require "rest_client"
require "json"
require "yaml"
require "active_support"

module Beintoo
  SERVER_URL = "https://api.beintoo.com/api/rest/"
  SANDBOX_SERVER_URL = "https://sandbox.beintoo.com/api/rest/"

  DEFAULT_HEADER = {
    'accept' => '*/*',
    'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8',
    'X-BEINTOO-SDK-VERSION' => '0.0.1-ruby'
  }


  class << self
    attr_accessor :apikey, :sandbox, :debug, :transformer, :redirect_uri, :logger
    LOG_DEBUG   = 0
    LOG_INFO    = 1
    LOG_WARNING = 2
    LOG_ERROR   = 3

    def configure
      yield self
      self.sandbox = false if sandbox != true
      if defined? Rails
        self.logger = Rails.logger
      end
    end

    def log(message, level = LOG_DEBUG)
      begin
        if defined? Rails
          case level
          when LOG_DEBUG
            self.logger.debug message
          when LOG_INFO, LOG_WARNING
            self.logger.info message
          when LOG_ERROR
            self.logger.error message
          end
        elsif self.logger.is_a?(String) && self.logger == "file"
          if @log_file.nil?
            @log_file = File.open 'beintoo_log.log', 'a'
          end
          if debug || level >= LOG_INFO
            @log_file.write message + "\n"
          end
        end
      rescue Exception => e
        puts e.message
      end
    end

    def build_headers(headers = {})
      raise Beintoo::ApiException, "Api Key not provided" if Beintoo::apikey.nil?
      {apikey: apikey, sandbox: sandbox}.merge headers
    end

    def get(url, headers = {}, params = {})
      url = "#{Beintoo::SERVER_URL}#{url}"
      start = Time.now
      headers.merge! Beintoo::DEFAULT_HEADER
      url += "?#{hash_to_params(params)}" unless params.empty?

      log "#"*80
      log "       Calling Beintoo Api"
      log url
      log headers.inspect
      log "#"*80

      resource = RestClient::Resource.new url, headers: headers

      log "Connecting GET to #{url} with headers #{headers}"

      begin
        response = resource.get
        stop = Time.now
        http_code = response.code

        log "------  RAW RESULT  ------"
        log response.body
        log "------ /RAW RESULT  ------"

        result = JSON.parse(response.body)
        result = result.with_indifferent_access if result.is_a? Hash
        result
      rescue RestClient::Exception => e
        log "Exception grabbed, response is", LOG_ERROR
        log e.response.inspect, LOG_ERROR
        log e.inspect, LOG_ERROR
        mex = JSON.parse(e.response)["message"]
        if mex == "An user with this email already registered"
          raise Beintoo::UserAlreadyRegisteredException, mex
        else
          raise Beintoo::ApiException, mex
        end
      end
    end

    def post(url, headers = {}, params = {})
      url = "#{Beintoo::SERVER_URL}#{url}"
      start = Time.now
      headers.merge! Beintoo::DEFAULT_HEADER
      ll = {"Content-Type" => nil}
      headers.merge! ll
      if params.empty?
        params = ""
      end

      log "#"*80
      log "       Calling Beintoo Api"
      log url
      log headers.inspect
      log "#"*80

      resource = RestClient::Resource.new url, headers: headers
      if debug
        Beintoo.log "Connecting POST to #{url} with headers #{headers}"
        Beintoo.log "and posting #{params.inspect}"
      end
      begin
        response = resource.post params

        stop = Time.now
        http_code = response.code
        result = JSON.parse(response.body).with_indifferent_access
        log "RESULT IS #{result.inspect}"
        result
      rescue RestClient::Exception => e
        log "Exception grabbed, response is", LOG_ERROR
        log e.response.inspect, LOG_ERROR
        log e.inspect, LOG_ERROR
        mex = JSON.parse(e.response)["message"]
        if mex == "An user with this email already registered"
          raise Beintoo::UserAlreadyRegisteredException, mex
        else
          raise Beintoo::ApiException, mex
        end
      end
    end

    def hash_to_params(data = {})
      out = []
      data.each do |k, v|
        if ![Hash, Array].include? v.class
          out << "#{k.to_s}=#{v.to_s}"
        end
      end
      out.join '&'
    end

    # generates beintoo-connect url when user creation fails 
    # XXX logged_uri parameter is from php API but don't know yet how it works
    # see http://documentation.beintoo.com/home/api-docs/user-player-connection
    # redirect will have param userext=XXXXXXXXXXXXXyouruserGUID
    def get_connect_url(guid, display=nil, signup="facebook", logged_uri=nil)
      return false if guid.nil?
      url = "http://www.beintoo.com/connect.html?guid=#{guid}&apikey=#{self.apikey}&redirect_uri=#{self.redirect_uri}"
      unless display.nil?
        url += "&display=#{display}"
      end
      url += "&signup=#{signup}"
      unless logged_uri.nil?
        url += "&logged_uri=#{logged_uri}"
      end
      url
    end

  end
end
