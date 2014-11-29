json.array!(@comments) do |comment|
  json.extract! comment, :id, :description, :quantity, :price, :installation_id
  json.url comment_url(comment, format: :json)
end
