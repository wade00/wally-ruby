require 'rubygems'
require 'sinatra'
require 'twilio-ruby'

include WallyApp

get '/incoming-message' do
  words = params['Body'].gsub(/[.?!,]/, '').split(' ').delete_if do |w|
    ['can', 'i', 'recycle', 'be', 'recycled'].include?(w.downcase)
  end
  twiml = Twilio::TwiML::Response.new { |r| r.Message WallyApp::Base.new(words.join(' ')).query_results }
  twiml.text
end
