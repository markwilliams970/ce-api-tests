require 'rspec'
require 'httpclient'
require 'pp'
require 'json'

require File.dirname(__FILE__) + "/auth_keys.rb"

def make_req_url(hub, endpoint, version)
	return "#{@base_url}/elements/api-#{version}/hubs/#{hub}/#{endpoint}"
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
	
	# JSON data
	contact_file                                   = File.dirname(__FILE__) + "/json/contactsfdcmar.json"
	@contact_json                                  = File.read(contact_file)
  end

  it "should create a contact" do
  	
  	contact_url = make_req_url("marketing", "contacts", "v2")
  	
  	req_method = :post

	req_args = {
		:header => @req_headers,
		:body   => @contact_json
	}

	response = @my_http_client.request(req_method, contact_url, req_args)
	response_http_status = response.status_code
  	expect(response_http_status).to eq(200)
  end

end