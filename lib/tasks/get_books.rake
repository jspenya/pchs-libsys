namespace :get_books do
  desc "Get books from Google Books API"
  task :get_books => :environment do       
    url = "https://www.googleapis.com/books/v1/volumes?q=dog&maxResults=40&key=#{Rails.application.secrets.google_api_key}"
    response = HTTParty.get(url)    
    
    response["items"].each do |item|
      # 1. Build category
      category = Subject.new
      category.name = item["volumeInfo"]["categories"] || ""
      category.save

      # 2. Build book
      book = Book.new
      book.isbn = item["volumeInfo"]["industryIdentifiers"][0]["identifier"] || ""
      book.title = item["volumeInfo"]["title"] || ""
      book.author = item["volumeInfo"]["authors"]&.split(",")&.join(", ") || ""
      book.publisher = item["volumeInfo"]["publisher"] || ""
      book.thumbnail_image_url = item["volumeInfo"]["imageLinks"]["smallThumbnail"] || ""
      book.subject_id = category.id
      book.description = item["volumeInfo"]["description"] || ""
      book.borrow_duration = 56 # 56 Days
      book.save
    end
    puts "Export complete!"          
  end
end
