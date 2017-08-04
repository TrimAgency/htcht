FROM ruby:set_ruby_version
MAINTAINER stevetwitte@gmail.com

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  locales \
  nodejs

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir -p /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install

ADD . /app
