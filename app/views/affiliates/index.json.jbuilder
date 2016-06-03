json.array!(@affiliates) do |affiliate|
  json.extract! affiliate, :id, :domain, :referral
  json.url affiliate_url(affiliate, format: :json)
end
