require 'rspec'
require 'httpclient'
require 'pp'
require 'json'

require File.dirname(__FILE__) + "/auth_keys.rb"

def make_req_url(hub, endpoint, version)
   return "#{@base_url}/elements/api-#{version}/hubs/#{hub}/#{endpoint}"
end

def make_req(req_type, hub, endpoint, version, json_file_name)

   if req_type == :post then
      json_file                = File.dirname(__FILE__) + "/json/#{json_file_name}"
      json_string              = File.read(json_file)
      args                     = {:header => @req_headers, :body => json_string}
   elsif req_type == :get then
      args                     = {:header => @req_headers}
   end

   req_url = make_req_url(hub, endpoint, version)

   req = {
      :method => req_type,
      :url => req_url,
      :args => args
   }

   puts "Testing #{req_type} against #{req_url}..."
   if req_type == :post then puts "Body: #{json_string}" end
   return req
end

describe "Marketing Hub Salesforce Contact CRUD Tests" do

  before :all do
   @ce_http_client                                = HTTPClient.new
   @ce_http_client.protocol_retry_count           = 2
   @ce_http_client.connect_timeout                = 300
   @ce_http_client.receive_timeout                = 300
   @ce_http_client.send_timeout                   = 300
   
   # Elements Server
   @base_url                                      = "https://api.cloud-elements.com"
   
   # Authentication information
   @element_token                                 = $salesforce_element_token
   @user_secret                                   = $salesforce_user_secret
   @authentication_key                            = "Element #{@element_token}, User #{@user_secret}"
   
   @req_headers = {}
   @req_headers["Authorization"]                  = @authentication_key
   @req_headers["Content-Type"]                   = "application/json"
   
  end

  it "should create a contact" do
   
   contact_request      = make_req(:post, "marketing", "contacts", "v2", "contactsfdcmar.json")
   response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
   response_http_status = response.status_code
   puts response.inspect
   expect(response_http_status).to eq(200)
  end

end