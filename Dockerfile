FROM ruby:3.2.2

# Install dependencies
RUN apt-get update -qq && apt-get install -y \
  nodejs \
  yarn \
  build-essential \
  libpq-dev \
  chromium-driver \
  libnss3 libgconf-2-4\
  && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Install Bundler and Rails dependencies
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application code
COPY . ./

# Set environment variables (adjust RAILS_MASTER_KEY if necessary)
ENV RAILS_SECRET_KEY_BASE=75e44075db00f5edff48e22eac2930ca6f802b3c3429e277fbbe33840eed1aed58886fea6be4daba78f5a63b2ad4e06042815e6b05b396311cd3cd67a5392f34
ENV RAILS_MASTER_KEY=39887745612faa284de06bfab65c518e

# Set environment variable for Rails environment
ENV RAILS_ENV=production

# Precompile assets in production
RUN bundle exec rake assets:precompile

# Expose the port the app runs on
EXPOSE 3000

# Set the entry point for the application
#CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]