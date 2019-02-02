# reely

[![Build Status](https://gitlab.com/reely/reely/badges/master/build.svg)](https://gitlab.com/reely/reely/pipelines)


# Production Deploy

Create an environment file using the provided template. Follow the instructions inside that file to set the environment.

```
cp .env.deploy.sample .env.production
```

Install dependencies:

```
bundle install
yarn install
```

Build the schema:

```
RAILS_ENV=production bundle exec rake db:create
RAILS_ENV=production bundle exec rake db:migrate
```

Build the assets:

```
RAILS_ENV=production bundle exec rake assets:precompile
```

Start the app:

```
RAILS_ENV=production bundle exec puma -C config/puma.rb
```
