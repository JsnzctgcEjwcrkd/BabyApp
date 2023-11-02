FROM ubuntu:20.04
SHELL ["/bin/bash", "-c"]
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
       curl \
       systemd \
       sqlite3 \
       libsqlite3-dev \
       gcc \
       make \
       libssl-dev \
       zlib1g-dev \
       neovim \
       g++ \
       mysql-client \
       libmysqlclient-dev \
       nginx \
       software-properties-common \
       libyaml-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && apt-get install -y nodejs
RUN add-apt-repository ppa:git-core/ppa && apt-get update && apt-get upgrade git -y
RUN rm -rf /var/lib/apt/lists/*
RUN npm install --global yarn
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN cd ~/.rbenv && src/configure && make -C src
ENV PATH $PATH:/root/.rbenv/bin
ENV PATH $PATH:/root/.rbenv/shims
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
RUN mkdir -p "$(rbenv root)"/plugins
RUN git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
RUN rbenv install 3.2.2
RUN rbenv global 3.2.2
RUN rbenv rehash

WORKDIR /var/www/baby_app
COPY Gemfile Gemfile.lock package.json yarn.lock ./
RUN gem install bundler -v '2.2.30' && \
    bundle install && \
    yarn install --network-timeout 600000

EXPOSE 3000