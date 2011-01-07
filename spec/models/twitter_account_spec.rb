require 'spec_helper'

describe TwitterAccount do
  let :valid_params do
    { 
      :handle => "test", 
      :access_token => "asdf", 
      :access_token_secret => "asdf"
    }
  end

  let :account do
    TwitterAccount.new(valid_params)
  end

  it "is valid with valid attributes" do
    account.should be_valid
  end

  it "is not valid without an access token" do
    account.access_token = nil
    account.should_not be_valid
  end

  it "is not valid without an access token secret" do
    account.access_token_secret = nil
    account.should_not be_valid
  end
  it "is not valid without a twitter handle" do
    account.handle = nil
    account.should_not be_valid
  end
end