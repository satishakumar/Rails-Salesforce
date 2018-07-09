	oauth_url = "https://login.salesforce.com/services/oauth2/token"

	uri = URI.parse(oauth_url)

	http = Net::HTTP.new(uri.host, uri.port)

	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE


	data = "grant_type=password&client_id=xxxx&client_secret=xxxx&username=xxxx&password=xxxx"

	headers = {
	'Content-Type' => 'application/x-www-form-urlencoded'
	}

	# Get Access Token
	resp = http.post(uri.path, data, headers)

	json = JSON.parse(resp.body)

	access_token = json["access_token"]
	instance_url = json['instance_url']

	# Retrieves all sobjects
	uri = URI.parse("#{instance_url}/services/data/v43.0/sobjects")
	http = Net::HTTP.new(uri.host, uri.port)
	http.use_ssl = true
	http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	request = Net::HTTP::Get.new(uri.request_uri,{
		'Content-Type' => 'application/json',
		'Authorization' => "Bearer #{access_token}",
		'accept' => 'application/json'
	})

	resp = http.request(request)

	json_response = JSON.parse(resp.body)
	sobjects = json_response['sobjects']

	sobjects.each do |sobject|
		#Iterate over each Sobject and retrieve sobject metadata
		uri = URI.parse("#{instance_url}/services/data/v43.0/sobjects/#{sobject['name']}/describe")
		http = Net::HTTP.new(uri.host, uri.port)
		http.use_ssl = true
		http.verify_mode = OpenSSL::SSL::VERIFY_NONE

		request = Net::HTTP::Get.new(uri.request_uri,{
			'Content-Type' => 'application/json',
			'Authorization' => "Bearer #{access_token}",
			'accept' => 'application/json'
		})

		resp = http.request(request)

		sobject_describe = JSON.parse(resp.body)
		Rails.logger.info ">>>>>>>>>>>>#{sobject_describe.inspect}"

	end
