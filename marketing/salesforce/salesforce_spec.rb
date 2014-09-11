require 'rspec'
require 'httpclient'
require 'pp'
require 'json'

require File.dirname(__FILE__) + "/auth_keys.rb"

def make_req_url(hub, endpoint, version)
	return "#{@base_url}/elements/api-#{version}/hubs/#{hub}/#{endpoint}"
end

def make_post_req(json_file_name, hub, endpoint, version)

	json_file                                   = File.dirname(__FILE__) + "/json/#{json_file_name}"
	json_string                                 = File.read(json_file)

	post_req = {
		:method => :post,
		:url => make_req_url(hub, endpoint, version),
		:args => {:header => @req_headers, :body => json_string}
	}
	return post_req
end

describe "Marketing Hub Salesforce Contact CRUD Tests" do

  before :all do
	@my_http_client                                = HTTPClient.new
	@my_http_client.protocol_retry_count           = 2
	@my_http_client.connect_timeout                = 300
	@my_http_client.receive_timeout                = 300
	@my_http_client.send_timeout                   = 300
	
	# Elements Server
	@base_url                                      = "https://api.cloud-elements.com"
	
	# Authentication information
	@element_token                                  = $salesforce_element_token
	@user_secret                                    = $salesforce_user_secret
	@authentication_key                             = "Element #{@element_token}, User #{@user_secret}"
	
	@req_headers = {}
	@req_headers["Authorization"]                  = @authentication_key
	@req_headers["Content-Type"]                   = "application/json"
	
  end

  it "should create a contact" do
  	
	contact_request      = make_post_req("contactsfdcmar.json", "marketing", "contacts", "v2")
	response             = @my_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
	response_http_status = response.status_code
  	expect(response_http_status).to eq(200)
  end

end