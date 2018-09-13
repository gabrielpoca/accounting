# Accounting

This is a CLI utility that I use to explore my finances. I can drill down on my
expenses using simple commands.

[![asciicast](https://asciinema.org/a/tTk5tqtMxoZSv6EvTW1ZP9jeX.png)](https://asciinema.org/a/tTk5tqtMxoZSv6EvTW1ZP9jeX)

## Installation

```
bin/setup
```

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

#### Options

Use `-d` to see which expenses add up to a value:

```
exe/accounting explore month,category=groceries -d
```

use `-f` to choose which CSV files to load

```
exe/accounting explore -f="./priv/*.csv" month,category=groceries
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/gabrielpoca/accounting. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2018 Gabriel Poça. See [MIT License](LICENSE.txt) for further
details.
