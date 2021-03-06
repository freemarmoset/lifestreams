class TwitterController < ApplicationController
  def connect
    @consumer = TwitterController.consumer
    
    @request_token = @consumer.get_request_token(:oauth_callback => ENV['TWITTER_CALLBACK_URL'])
    
    session[:request_token] = @request_token.token
    session[:request_token_secret] = @request_token.secret

    redirect_to @request_token.authorize_url
    return
  end

  def callback
    @request_token = OAuth::RequestToken.new(TwitterController.consumer,
                                             session[:request_token],
                                             session[:request_token_secret])
    #TODO catch unauthorized request token
    @access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])

    #TODO only create/authorize an account once
    @account = TwitterAccount.new(
      :access_token => @access_token.token, 
      :access_token_secret => @access_token.secret, 
      :handle => @access_token.params[:screen_name],
      :user_id => current_user.id)

    if @account.save
      redirect_to user_root_path, :notice => 'You successfully authorized your Twitter account.'
    else 
      redirect_to user_root_path, :notice => 'There was an issue authorizing your Twitter account. Please try again.'
    end

  end

  def self.consumer
    OAuth::Consumer.new ENV['TWITTER_CONSUMER_KEY'], 
      ENV['TWITTER_CONSUMER_SECRET'], 
      {
        :site => 'https://api.twitter.com/',
        :request_token_path => '/oauth/request_token',
        :access_token_path => '/oauth/access_token',
        :authorize_path => 'oauth/authorize'

      }
  end
end
