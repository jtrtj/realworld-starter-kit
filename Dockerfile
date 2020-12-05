FROM ruby:2.7.1

WORKDIR /var/app/
COPY Gemfile* /var/app/

RUN gem install bundler && bundle install
