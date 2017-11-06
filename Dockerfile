FROM ruby
COPY . /app 
WORKDIR /app
RUN bundle install
CMD ruby /app/deploy.rb
