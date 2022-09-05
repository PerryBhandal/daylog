json.array!(@premade_tasks) do |premade_task|
  json.extract! premade_task, :id, :name
  json.url premade_task_url(premade_task, format: :json)
end
