ARG RUBY_VERSION=3.1.6
FROM ruby:$RUBY_VERSION-slim-bullseye

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    git \
    nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir /portfolio
WORKDIR /portfolio
ADD Gemfile /portfolio/Gemfile
ADD Gemfile.lock /portfolio/Gemfile.lock

ARG BUNDLER_VERSION=2.3.26
RUN gem update --system \
    && gem install bundler:$BUNDLER_VERSION \
    && bundle config set force_ruby_platform true
RUN bundle install
ADD . /portfolio