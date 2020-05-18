# Prerequisites

1. Install Ruby
2. `gem install bundler`
3. `bundle install`

## Running Specs

`bundle exec rspec` or `bundle exec guard`

## Running solution
1. cd into `ruby_edition` folder
2. Run `ruby web/index.rb` or `shotgun web/index.rb -p 3000`
3. Go to `http://localhost:3000` on your browser
4. Input any of the query parameters and click on the `Download ICS File` button to returned a filtered list
5. To download an unfiltered list, only click on the `Download ICS File` button
6. Alternatively, you can visit ` http://localhost:3000?userId=644` and `http://localhost:3000?startDate=2017-01-01&endDate=2017-02-01` to download a filtered list
7. Downloaded files are also stored in `ruby_edition/invites`

## Files added
1. `ruby_edition/web/index.rb`
2. `ruby_edition/web/index.erb`

