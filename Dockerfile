FROM buildpack-deps:jessie

ENV HOME /Frontend-Starter-Kit

WORKDIR ${HOME}
ADD . $HOME

# node --
ENV NODE 8

RUN \
  curl -sL https://deb.nodesource.com/setup_$NODE.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update && \
  apt-get install -y nodejs yarn
# -- node

# chrome --
ENV CHROME_BIN /usr/bin/chromium
ENV DISPLAY :99

RUN \
  apt-get update && \
  apt-get install -y xvfb chromium libgconf-2-4

ENTRYPOINT ["Xvfb", "-ac", ":99", "-screen", "0", "1280x720x16"]
# -- chrome

# puppeteer --
RUN \
  apt-get update && apt-get install -y wget --no-install-recommends && \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install -y google-chrome-unstable --no-install-recommends && \
  apt-get purge --auto-remove -y curl
# -- puppeteer

RUN \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /src/*.deb

RUN yarn install

EXPOSE 8000 8080
