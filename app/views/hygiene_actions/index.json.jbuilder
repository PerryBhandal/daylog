json.array!(@hygiene_actions) do |hygiene_action|
  json.extract! hygiene_action, :id, :action_time, :actions, :comments
  json.url hygiene_action_url(hygiene_action, format: :json)
end
