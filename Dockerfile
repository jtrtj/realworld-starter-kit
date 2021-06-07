FROM ruby:3.0.1

WORKDIR /var/app/
COPY Gemfile* /var/app/

RUN apt-get update && apt-get install -y \
    libaio1 \
    locales \
    && locale-gen en_US.UTF-8 \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/* \
    && wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 \
    && chmod +x /usr/local/bin/dumb-init

ENV LC_ALL=en_US.UTF-8 \
LANG=en_US.UTF-8 \
LANGUAGE=en_US:en

RUN gem install bundler && bundle install

ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]

CMD rackup --host 0.0.0.0
