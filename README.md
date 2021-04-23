<p align="center"><a href="https://glimmerhq.com/anikuto/anikuto" target="_blank" rel="noopener"><img src="https://user-images.githubusercontent.com/56767/56467671-fdd6ea80-645c-11e9-9056-a5d3fd5739e6.png" width="130" /></a></p>

# Anikuto ![CircleCI](https://img.shields.io/circleci/build/gh/anikuto/anikuto?logo=circleci) ![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/anikuto/anikuto?logo=code%20climate) ![Code Climate coverage](https://img.shields.io/codeclimate/coverage/anikuto/anikuto?logo=code%20climate)

The platform for all things anime.

## Requirements

To run Anikuto on a local machine, you need to have the following dependencies installed:

- [Ruby](https://www.ruby-lang.org) 2.7.2
- [Docker](https://www.docker.com)
- [Docker Compose](https://docs.docker.com/compose/)


## Running the app

```
$ sudo sh -c "echo '127.0.0.1  anikuto.test' >> /etc/hosts"
$ sudo sh -c "echo '127.0.0.1  anikuto-jp.test' >> /etc/hosts"
$ git clone https://github.com/anikuto/anikuto.git
$ cd anikuto
$ bundle install
$ touch .env.development.local
$ bundle exec rails db:setup
$ docker-compose up --build
$ bundle exec rake jobs:work
$ bundle exec rails s
```

You should then be able to open [http://anikuto.test:3000](http://anikuto.test:3000) (or [http://anikuto-jp.test:3000](http://anikuto-jp.test:3000)) in your browser.


#### Running the tests

```
// Run all tests
$ bundle exec rspec
// Run system spec with headless browser
$ bundle exec rspec spec/system/xxx_spec.rb
// Run system spec with local browser (Open browser on local machine)
$ NO_HEADLESS=true bundle exec rspec spec/system/xxx_spec.rb
```


### License

Copyright 2021 Anikuto

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
