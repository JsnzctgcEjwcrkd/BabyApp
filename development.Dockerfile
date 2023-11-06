FROM ubuntu
SHELL ["/bin/bash", "-c"]
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN rm -rf /var/lib/apt/lists/* && apt-get update && apt-get install -y \
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
       openssl \
       gosu \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && apt install -y nodejs
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
RUN rbenv install $(rbenv install -l | grep -v - | tail -1)
RUN rbenv global $(rbenv install -l | grep -v - | tail -1)
RUN rbenv rehash
RUN gem update --system

RUN gem install bundler && \
    bundle config build.mysql2 "--with-openssl-lib=$(rbenv root)/versions/$(rbenv install -l | grep -v - | tail -1)/openssl/lib64/"
ENV NODE_OPTIONS --openssl-legacy-provider

EXPOSE 3000