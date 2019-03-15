# reely

[![Build Status](https://gitlab.com/reely/reely/badges/master/build.svg)](https://gitlab.com/reely/reely/pipelines)


# Development / Test Setup

Create an environment file using the provided template. Follow the instructions inside that file to set the environment.

```
cp .env.development.sample .env.development
```

Install dependencies:

```
bundle install
yarn install
```

Install [`imagemagick`](www.imagemagick.org/), used for image manipulation and analysis.

```
brew install imagemagick            # OSX
sudo apt-get install imagemagick    # Debian / Ubuntu
```

Install githooks, if you plan on committing or contributing to Reely.
The script below registers a new hook under the `.git/hooks/pre-commit` which will run all the linters and stylers under `contrib/hooks/scripts/*`.

```
bin/install-githooks
```

Build the schemas:

```
# Creates both development and test databases
RAILS_ENV=development bundle exec rake db:create

# Doesnt migrate test schema, but that's done automatically
# at the start of each test run anyway
RAILS_ENV=test bundle exec rake db:migrate
```

Run tests (if you want to):

```
bin/rspec
```

Start the app:

```
bin/foreman start -f Procfile.dev
```

# Production Deploy

Create an environment file using the provided template. Follow the instructions inside that file to set the environment.

```
cp .env.production.sample .env.production
```

Install dependencies:

```
bundle install
yarn install
```

Install [`imagemagick`](www.imagemagick.org/), used for image manipulation and analysis.

```
brew install imagemagick            # OSX
sudo apt-get install imagemagick    # Debian / Ubuntu
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
RAILS_ENV=production bin/foreman start
```
