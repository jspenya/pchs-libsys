Environment
--------
Ruby Version: Ruby 2.6.7
Rails Version: Rails 5.2.5
Database: PostgreSQL
Others:
Delayed Job (Optional)
ElasticSearch (Optional)

Development Setup
--------
1. Clone repository: `git clone https://github.com/penyakamaayo/pchs-libsys.git`
2. cd into repository `cd pchs-libsys`
3. Make sure you are running on Ruby v2.6.7
  * If you're on RVM: `rvm use 2.6.7`
  * If you're on RBENV, temporarily switch version on current shell by: `rbenv shell 2.6.7`
4. Run `bundle`
5. Setup Postgres & add user with username: `library_development` and password: `library_development`. Make sure to grant create database privileges
6. Run `rake db:setup`
7. Login Credentials
  * Admin - email: `admin@lib.com` password: `admin123`
  * Student - email: `student@lib.com` password: `student123`

Populate books via Google Books API
--------
1. Setup Google Books API key
2. Put API key inside secret by running: `EDITOR="code --wait" bin/rails credentials:edit`. Replace `code` with your editor. Save then close file.
3. Check `get_books.rake` rakefile to see if secret matches. `Rails.application.secrets.your_secret_name_here`
4. Run `rake get_books:getbooks`
