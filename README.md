# MAGIC COMMAND LINE TOOL

## Setup

1. Install and run `bundle`

```
gem install bundle
bundle
```

2. In your terminal, give executable permissions to `start`

```
chmod 755 start
```

3. Execute `start` file

```
./start
```

4. It is recommended to download data first

```
./magic -d
```

5. Otherwise you can see other options with

```
./magic -h
```

6. Run tests with rspec

```
rspec
```


## Magic command line options

You can use the following command line options to interact with this application

```
 -d, --download                   Download the cards from the API
 -g, --group-by p1,p2             Group results by property (set or rarity)
 -s, --set setKey                 Filter results by set key. Ex: KTK
 -c, --color c1,c2                Filter results by colors (capitalized: Red,Blue)
 -p, --page number                Show this page for the results. Default 1
 -h, --help                       Prints this help
```
 Examples:

```
./magic -d
./magic -g set
./magic -g set,rarity
./magic -s KTK -c Blue,Red
./magic -s 2XM
./magic -s 2XM -p 23
```

## Utilities

If you want to explore the local db. You can use the following in your terminal:

```
APP_ENVIRONMENT=development irb -r ./lib/models/color.rb -r ./lib/models/card.rb -r ./lib/models/cards_color.rb
```

Then you can explore the content, similar to `rails c`. Ex:

```
Card.count
```

## Implementation Notes

To download the data, I decided to handle the requests using threads to in order to parallelize the work a bit instead of doing it sequentially. The data is kept in memory and then is saved into a local db. All this process is handled in the `CardsDownloader`service. Data fetching is handled with `CardsFetcher` that uses a generic `HttpClient`to consume the API.

The database I'm using is sqlite, I think the flat file format was enough for this challenge. There are some drawbacks about using this database that, for example it doesn't support multithread connections, that's why the data had to be stored in bulk once all the fetching of the API was completed. The service `CardsImporter` is the one responsible for this job.

The database schema consist of three tables: `Cards`, `Colors` and `Cards_Colors`. Each of these tables has their respective model in `models`directory. Currently, only the fields required in the challenge are supported: set, rarity, colors.To interact with the database I decided to use ActiveRecord and follow a pattern similar to rails.

All the process for searching and grouping cards is done once the data is downloaded with the service `SearchCards`. Decided to include a single service for all the operations required in the challenge. But I think this can evolve a bit and separate the concerns about grouping and filtering. But for the time being I think it works ok.


## About dependencies

| Gem      | Use |
| ----------- | ----------- |
|`activerecord`| ORM to interact with the database|
|`dotenv`| Manage environment variables|
|`faraday`| Handle http requests|
|`faraday-retry`| Handle retries and errors with faraday|
|`kaminari`| Paginate models |
|`pry-byebug`| Debug|
|`sqlite3`| Database|
|`factory_bot`| Testing. Mock data|
|`faker`| Testing. Mock data|
|`rubocop`| Linter|
|`database_cleaner-active_record`| Testing. Clean data between test runs|
|`rspec`| Testing|
|`vcr`| Testing. Mock http requests |
|`webmock`|Testing. Mock http requests|

