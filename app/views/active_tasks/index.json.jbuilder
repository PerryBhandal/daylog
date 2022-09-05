json.array!(@active_tasks) do |active_task|
  json.extract! active_task, :id, :task_name, :start_time
  json.url active_task_url(active_task, format: :json)
end
