require 'rspec'
require 'httpclient'
require 'pp'

require File.dirname(__FILE__) + "/auth_keys.rb"

describe "Marketing Hub Salesforce Contact CRUD Tests" do

  before :all do
	@my_http_client                                = HTTPClient.new
	@my_http_client.protocol_retry_count           = 2
	@my_http_client.connect_timeout                = 300
	@my_http_client.receive_timeout                = 300
	@my_http_client.send_timeout                   = 300
	
	# Authentication information
	@element_token                                  = $salesforce_element_token
	@user_secret                                    = $salesforce_user_secret
	@authentication_key                             = "Element #{@element_token}, User #{@user_secret}"
	
	puts @authentication_key
	
	@req_headers = {}
	@req_headers["Authorization"]                  = @authentication_key
	@req_headers["Content-Type"]                   = "application/json"
  end

  it "should create a contact" do
  	contact = {}
  	contact["firsName"] = "Your"
  	contact["lastName"] = "Mom"
  	contact["phone"] = "777-777-7777"
  	contact["email"] = "yourmom@acmedataservices"
  	
  	address = {}
  	address["stateOrProvince"] = "CO"
  	address["postalCode"] = "80212"
  	address["country"] = "US"
  	
  	contact["address"] = address
  	
  	contact_url = "https://api.cloud-elements.com/elements/api-v2/hubs/marketing/contacts"
  	
  	req_method = :post

	req_args = {
		:header => @req_headers,
		:body   => contact
	}

	response = @my_http_client.request(req_method, contact_url, req_args)
	puts response.inspect
	var1 = 1
	var2 = 2
  	expect(var1).to eq(var2)
  end

end