json.array!(@pills) do |pill|
  json.extract! pill, :id, :consumed_at, :pill_name, :quantity
  json.url pill_url(pill, format: :json)
end
