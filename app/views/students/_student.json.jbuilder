json.extract! student, :id, :lrn, :firstname, :lastname, :created_at, :updated_at
json.url student_url(student, format: :json)
