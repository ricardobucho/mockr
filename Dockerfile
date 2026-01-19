ARG RUBY_VERSION=3.3.6

FROM ruby:$RUBY_VERSION
LABEL maintainer="Ricardo Bucho <ricardobucho@live.com>"

# Set the working directory
WORKDIR /app

# Install dependencies
RUN apt-get update -qq \
  && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    libpq-dev \
    postgresql

# Install Node.js using NVM
COPY .nvmrc ./
ENV NVM_VERSION v${NVM_VERSION:-0.39.3}
ENV NODE_VERSION v${NODE_VERSION:-20.18.1}
ENV NVM_DIR /usr/local/nvm
RUN mkdir $NVM_DIR

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash \
  && /bin/bash -c "source $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default"

# Install Yarn
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && npm install -g yarn"

# Clean up
RUN apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Copy the application into the container
COPY . .

# Install bundler and gems
RUN gem install bundler:$(ruby -e "puts File.read('Gemfile.lock').match(/BUNDLED WITH\n\s+(.*)/)[1]")
RUN bundle config --global frozen 1
RUN bundle install --jobs 8 --retry 5

# Install node modules and precompile assets
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && yarn install --check-files"
RUN /bin/bash -c "source $NVM_DIR/nvm.sh && bundle exec rails assets:precompile"

# Set the entrypoint
COPY ./bin/builds/docker.sh ./bin/builds/docker.sh
RUN chmod +x ./bin/builds/docker.sh
ENTRYPOINT ["./bin/builds/docker.sh"]

# Expose port 3000 to the Docker host
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
