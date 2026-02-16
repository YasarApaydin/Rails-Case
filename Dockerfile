FROM ruby:3.3

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs

WORKDIR /app

ENV BUNDLE_PATH=/bundle

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .


CMD ["bash"]
