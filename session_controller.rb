require "json"
require "httparty"

class SessionController
  include HTTParty
  base_uri "https://expensable-api.herokuapp.com"

  def self.login(login_data)
    options = {
      headers: { "Content-Type": "application/json" },
      body: login_data.to_json
    }
    response = post("/login", options)
    raise_and_send_response(response)
  end

  # create_ logout

  def self.logout(token)
    options = { headers: { authorization: "Token token=#{token}" } }
    response = delete("/logout", options)
    raise_and_send_response(response)
  end

  def self.raise_and_send_response(response)
    response_body = JSON.parse(response.body, symbolize_names: true)
    raise Net::HTTPError.new(response_body[:errors].join, response) unless response.success?

    response_body
  end
end
