json.extract! advancement_history, :id, :robot_code, :advancement_code, :created_at, :updated_at
json.url advancement_history_url(advancement_history, format: :json)