FROM ruby:alpine
COPY . /app 
RUN cd /app && bundle install
CMD ruby /app/deploy.rb
