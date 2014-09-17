require 'rspec'
require 'httpclient'
require 'pp'
require 'json'
require './spec_helper_sfdc.rb'

require File.dirname(__FILE__) + "/auth_keys.rb"

describe "Marketing Hub Salesforce Contact CRUD Tests" do

    before :all do
		  sfdc_spec_conf = {
		  	:element_token => $salesforce_element_token,
		  	:user_secret => $salesforce_user_secret,
		  	:base_url => "https://api.cloud-elements.com"
		  }
          @sfdc_spec_helper                            = SpecHelperSFDC.new(sfdc_spec_conf)
          @ce_http_client                              = @sfdc_spec_helper.ce_http_client
    end

  it "should create a contact" do

        # We're doing a create, so have no ID to pass into request yet
        # but we require an object to pass into our function prototype
        null_id              = nil
        
        # File containing body of JSON to POST
        source_json_file     = "contactsfdcmar.json"
        
        # Create a request object/hash that we can use to call cloud-elements server
        contact_request      = @sfdc_spec_helper.make_req(:post, "marketing", "contacts", "v2", source_json_file)
        
        # Make request against cloud-elements server and get response status code
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        
        # Get response body and JSON-ify it
        response_body = response.body
        response_json = JSON.parse(response_body)
        
        # We'll need the ID of the contact created, for later on
        $contact_id = response_json["id"]
        
        # Output response
        puts "Response:"
        puts JSON.pretty_generate(response_json)
        @sfdc_spec_helper.write_json(source_json_file, response_json)
        
        # Evaluate test condition
        expect(response_http_status).to eq(200)
    end
  
    it "should update a contact" do
    
    	# File containing body of JSON to PATCH
        source_json_file     = "patchcontactsfdcmar.json"
        
        # Create a request object/hash that we can use to call cloud-elements server
        contact_request      = @sfdc_spec_helper.make_req(:patch, "marketing", "contacts", "v2", source_json_file, $contact_id)
        
        # Make request against cloud-elements server and get response status code
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        
        # Get response body and JSON-ify it
        response_body = response.body
        response_json = JSON.parse(response_body)
        
        # Output response
        puts "Response:"
        puts JSON.pretty_generate(response_json)
        @sfdc_spec_helper.write_json(source_json_file, response_json)
        
        # Evaluate test condition
        expect(response_http_status).to eq(200)
    end
  
    it "should find a contact by ID" do
    
        # Dummy file name to pass our function prototype for parameter-matching
        # Obviously our GET request doesn't need to pass in json
        # However, we're going to follow a functional naming scheme so that our
        # response output filename makes sense
        source_json_file     = "findacontactsfdc.json"
    
    	# Create a request object/hash that we can use to call cloud-elements server
        contact_request      = @sfdc_spec_helper.make_req(:get, "marketing", "contacts", "v2", source_json_file, $contact_id)
        
        # Make request against cloud-elements server and get response status code
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        
        # Get response body and JSON-ify it
        response_body = response.body
        response_json = JSON.parse(response_body)
        
        # Output response
        puts "Response:"
        puts JSON.pretty_generate(response_json)
        @sfdc_spec_helper.write_json(source_json_file, response_json)
        
        # Evaluate test condition
        expect(response_http_status).to eq(200)
    end
  
    it "should delete a contact by ID" do
    
    	# Dummy file name to pass our function prototype for parameter-matching
        # Obviously our GET request doesn't need to pass in json
        # However, we're going to follow a functional naming scheme so that our
        # response output filename makes sense
        source_json_file     = "deleteacontactsfdc.json"
        
        # Create a request object/hash that we can use to call cloud-elements server
        contact_request      = @sfdc_spec_helper.make_req(:delete, "marketing", "contacts", "v2", source_json_file, $contact_id)
        
        # Make request against cloud-elements server and get response status code
        response             = @ce_http_client.request(contact_request[:method], contact_request[:url], contact_request[:args])
        response_http_status = response.status_code
        
        # Evaluate test condition
        expect(response_http_status).to eq(200)
    end

end