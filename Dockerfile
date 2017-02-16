FROM ruby:2.2.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
RUN apt-get install build-essential chrpath libssl-dev libxft-dev -y \
      && apt-get install libfreetype6 libfreetype6-dev -y \
      && apt-get install libfontconfig1 libfontconfig1-dev -y

RUN set -xeu \
 \
  && PHANTOM_VERSION="phantomjs-2.1.1" \
  && ARCH=$(uname -m) \
  && PHANTOM_JS="$PHANTOM_VERSION-linux-$ARCH" \
  && wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2 \
  && tar xvjf $PHANTOM_JS.tar.bz2 \
  && mv $PHANTOM_JS /usr/local/share \
  && ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin \
  && rm -f $PHANTOM_JS.tar.bz2
