json.array!(@installations) do |installation|
  json.extract! installation, :id
  json.url installation_url(installation, format: :json)
end
