# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.5
FROM ruby:${RUBY_VERSION}-slim

ENV APP_HOME=/rails \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLER_VERSION=4.0.18

WORKDIR ${APP_HOME}

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential curl libyaml-dev pkg-config sqlite3 && \
    rm -rf /var/lib/apt/lists/* && \
    gem install bundler --version "${BUNDLER_VERSION}"

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

RUN chmod +x bin/docker-entrypoint && \
    mkdir -p tmp/pids storage public/uploads

EXPOSE 3000

ENTRYPOINT ["bin/docker-entrypoint"]
CMD ["bin/rails", "server", "--binding", "0.0.0.0"]
