Features
--------

- Signup/Login users
- Books CRUD
- Mail book details to user (Async)
- Subject-wise Categorization of Books
- Import books via CSV

Gems
----

- Carrierwave
- mini_magick
- file_validators
- devise
- sidekiq

Installation
------------

        git clone http://www.github.com/maanavshah/library-management

        cd library-management

        bundle install

        rake db:create

        rake db:migrate

        rails s

Usage
-----

1. Create project:

```ruby
    $ rails new library-management
```

2. Setup Postgres

- Create a postgres user

```ruby
    $ sudo -u postgres createuser maanavshah -s
```

- Login to psql

```ruby
    $ sudo -u postgres psql
```

- Set user's password

```ruby
    \password maanavshah
```

- Add the following line to gemfile

```ruby
    gem 'pg'
```

- Update the database.yml for postgres

- Setup library-management database

```ruby
    $ rake db:create
    $ rake db:migrate
```

3. Generate Book and Subject model

```ruby
    $ rails generate model Book
    $ rails generate model Subject
```

4. Generate Book and Subject migration

```ruby
    $ rails generate migration books
    $ rails generate migration subjects

    $ rails db:migrate
```

5. Generate controller

```ruby
    $ rails generate controller Book
```

6. Add Carrierwave for image storage

https://code.tutsplus.com/articles/uploading-with-rails-and-carrierwave--cms-28409

```ruby
    $ rails generate uploader Image

    $ rails generate migration add_image_to_books image:string

    $ rake db:migrate
```

7. Add Minimagic to generate thumbnail and support carrierwave

If images are already uploaded then run:

```ruby
    $ rails c
```

```ruby
    Book.find_each {|book| book.image.recreate_versions!(:thumb) if book.image?}
```

8. Adding Devise and User

https://guides.railsgirls.com/devise

```ruby
    $ bundle install
    $ rails g devise:install
```
Ensure you have defined default url options in your environments files. Open up config/environments/development.rb and add this line:

```ruby
   config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

```ruby
    $ rails g devise user
    $ rails db:migrate
```

9. Add ActionMailer

```ruby
    $ rails generate mailer UserMailer
```

10. Sidekiq with ActionMailer

https://gist.github.com/maxivak/690e6c353f65a86a4af9

You can create environment variables using:

http://railsapps.github.io/rails-environment-variables.html

Heroku Deployment
-----------------

https://devcenter.heroku.com/articles/getting-started-with-rails5


1.  Login heroku

        heroku login

2.  Add heroku remote library-management

        heroku git:remote -a library-management-7

3.  Push code heroku master

        git push heroku master

4.  Add postgresql addon to heroku

        heroku addons:create heroku-postgresql:hobby-dev

5.  Rake setup (No need for rake db:create)

        heroku run rake db:migrate

6.  Add environment variables GMAIL

        heroku config:add GMAIL_USERNAME=replymailer7@gmail.com
        heroku config:add GMAIL_PASSWORD=maanavshah@123

7.  Scale Web application

        heroku ps:scale web=1

8.  Open website in browser

        heroku open

9. Check Logs

        heroku logs
        heroku logs --tail

10. Bundle rails console and sidekiq

        heroku run bundle exec rails c
        heroku run bundle exec sidekiq

Gem alternatives
----------------

- devise        -  JWT (authentication and authorization)
- god           -  track sidekiq/nginx if disabled, then automatically re-enable
- foundation    -  bootstrap
- scss          -  sass mixin
- carrierwave   -  ActiveStorage
- state-machine
- kaminari
- turbolinks
- jbuilder
