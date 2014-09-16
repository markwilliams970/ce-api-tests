require 'rspec'
require 'httpclient'
require 'pp'
require 'json'
require './spec_helper_sfdc.rb'

require File.dirname(__FILE__) + "/auth_keys.rb"

describe "Marketing Hub Salesforce Lead CRUD Tests" do

    before :all do
		  sfdc_spec_conf = {
		  	:element_token => $salesforce_element_token,
		  	:user_secret => $salesforce_user_secret,
		  	:base_url => "https://api.cloud-elements.com"
		  }
          @sfdc_spec_helper                            = SpecHelperSFDC.new(sfdc_spec_conf)
          @ce_http_client                              = @sfdc_spec_helper.ce_http_client
    end

  it "should create a lead" do

        null_id              = nil
        contact_request      = @sfdc_spec_helper.make_req(:post, "marketing", "leads", "v2", "leadsfdcmar.json")
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        response_body_json = JSON.parse(response.body)
        $contact_id = response_body_json["id"]
        puts response.inspect
        expect(response_http_status).to eq(200)
    end
  
    it "should update a lead" do
        contact_request      = @sfdc_spec_helper.make_req(:patch, "marketing", "leads", "v2", "patchleadsfdcmar.json", $contact_id)
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        response_body = response.body
        puts response.inspect
        expect(response_http_status).to eq(200)
    end
  
    it "should find a lead by ID" do
        contact_request      = @sfdc_spec_helper.make_req(:get, "marketing", "leads", "v2", "nojsonneeded.json", $contact_id)
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        response_body = response.body
        puts response.inspect
        expect(response_http_status).to eq(200)
    end
  
    it "should delete a lead by ID" do
        contact_request      = @sfdc_spec_helper.make_req(:delete, "marketing", "leads", "v2", "nojsonneeded.json", $contact_id)
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        response_body = response.body
        puts response.inspect
        expect(response_http_status).to eq(200)
    end

end