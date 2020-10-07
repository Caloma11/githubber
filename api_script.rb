require 'httparty'

url = "http://localhost:3000/api/v1/github/manual"

response = HTTParty.post(url, body: { token: "batata_frita"})

p response
