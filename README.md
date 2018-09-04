# Accounting

This is a CLI utility that I use to explore my finances. I can drill down on my
expenses using simple commands.

## Installation

    $ gem install accounting

## Usage

### Expenses

Every CSV file in the `priv` folder will be loaded as expenses. To convert
expenses from xlsx we can use gnumeric:

```
ssconvert july.xlsx july.csv
```

To install gnumeric you can use brew:

```
brew install gnumeric
```

### Explore

The `explore` command is usefull to breakdown expenses by a set of attributes:

```
exe/accounting explore [attributes]
```

The attributes is one or more attributes separated by a comma: For instance, to
split the expenses by month, and for each month by category we can run the
following command:

```
exe/accounting explore month,category
```

To list the expenses for just one category we can use an attribute value. For
instance, to see how much I spent each month in groceries I can run the
following command:

```
exe/accounting explore month,category=groceries
```

The available attributes are:

- month
- category
- weekday

To see which expenses are behind a value use `-d` to get more details:

```
exe/accounting explore month,category=groceries -d
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/gabrielpoca/accounting. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2018 Gabriel Poça. See [MIT License](LICENSE.txt) for further
details.
