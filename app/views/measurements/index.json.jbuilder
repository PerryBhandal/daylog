json.array!(@measurements) do |measurement|
  json.extract! measurement, :id, :date, :time, :weight, :waist_extended, :waist_normal, :hip, :chest, :bicep, :forearm, :calves, :thighs
  json.url measurement_url(measurement, format: :json)
end
