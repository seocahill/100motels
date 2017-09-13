[![Build Status](https://travis-ci.org/seocahill/100motels.svg?branch=master)](https://travis-ci.org/seocahill/100motels)
[![Code Climate](https://codeclimate.com/github/seocahill/100motels/badges/gpa.svg)](https://codeclimate.com/github/seocahill/100motels)
[![Test Coverage](https://codeclimate.com/github/seocahill/100motels/badges/coverage.svg)](https://codeclimate.com/github/seocahill/100motels/coverage)

# 100 Motels

100 Motels was a crowdfunding platform for musicians to fund their tours that closed in 2012.

The site itself operated as a marketplace allowing users to operate crowdfunding compaigns for their gigs utilysing Stripe's connect API.

This source code here is a version of the original source now offered as a fullstack code sample for my current portfolio as all of my production rails apps are API only.

You can run this locally using 
```
  docker-compose up -d
``` 
although be warned that you may need stripe and filepicker api keys (see the .env file).

You can run the tests suite locally using 

```
  docker-compose -f docker-compose.test.yml run web bin/rake test
```

![100 Motels demo](motels.gif)

## Copyright

Copyright (c) 2010 Seo Cahill. See LICENSE for details.
