json.array!(@feedbacks) do |feedback|
  json.extract! feedback, :id, :name, :email, :message
  json.url feedback_url(feedback, format: :json)
end
