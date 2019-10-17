FROM ruby:2.5.1

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs imagemagick libimage-exiftool-perl

# App
RUN mkdir -p /app
WORKDIR /app
ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

# NodeJS
RUN mkdir -p /usr/local/nvm
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs
RUN node -v
RUN npm -v

# Yarn
# Install yarn via npm -_-
# See: https://rubyinrails.com/2019/03/29/dockerify-rails-6-application-setup/
COPY package.json yarn.lock ./
RUN npm install -g yarn
RUN yarn install --check-files --pure-lockfile

# Bundler
RUN gem install bundler -v 1.17.2
RUN gem install nokogiri -v 1.10.4 -- --use-system-libraries
COPY Gemfile Gemfile.lock ./
RUN bundle install --verbose --jobs 20 --retry 5 --deployment

# Setup
COPY . ./
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

# Run
ENTRYPOINT ["entrypoint.sh"]
CMD ["bundle", "exec", "foreman", "start"]
