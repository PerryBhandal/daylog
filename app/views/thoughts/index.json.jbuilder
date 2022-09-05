json.array!(@thoughts) do |thought|
  json.extract! thought, :id, :time_added, :thought
  json.url thought_url(thought, format: :json)
end
