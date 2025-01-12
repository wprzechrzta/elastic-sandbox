
# Start kibana and elasticsearch 
use docker-compose-single.yml

## Workshop repo
https://github.com/LisaHJung/Part-1-Intro-to-Elasticsearch-and-Kibana


http://localhost:5601/ - Kibana Web UI interface
http://localhost:9200/ - Elastic Search API

# Run in console
- create index
PUT favorite_candy


- index document
POST favorite_candy/_doc
{
  "first_name": "Lisa",
  "candy": "Sour Skittles"
}

Use PUT when you want to assign a specific id to your document(i.e. if your document has a natural identifier - purchase order number, patient id, & etc). For more detailed explanation, check out this documentation from Elastic!

```bash
PUT favorite_candy/_doc/1
{
  "first_name": "John",
  "candy": "Starburst"
}
```

GET favorite_candy/_doc/1

- _create Endpoint
   https://github.com/LisaHJung/Part-1-Intro-to-Elasticsearch-and-Kibana/blob/main/README.md#_create-endpoint

if id already exist it will report error
PUT favorite_candy/_create/1
{
  "first_name": "Finn",
  "candy": "Jolly Ranchers"
}


- update
```bash
POST favorite_candy/_update/1
{
  "doc": {
    "candy": "M&M's"
  }
}
```

- delete
DELETE favorite_candy/_doc/1


- search
GET favorite_candy/_search
{
  "query": {
    "match_all": {}
  }
}

## Adding data using kibana file upload

  https://www.youtube.com/watch?v=1lUnQPWPPgQ

  dataset: 
  https://www.kaggle.com/datasets/rmisra/news-category-dataset

  - all resources: 
  https://github.com/LisaHJung/Part-2-Understanding-the-relevance-of-your-search-with-Elasticsearch-and-Kibana-?tab=readme-ov-file

  Example:
  Import data from https://www.kaggle.com/datasets/rmisra/news-category-dataset using kibana FileVisualizer in Kibana/home/ingest section/fileUpload

  indexName: news_headline

# Basic search
  kibana/dev_console: 
  > GET news_headline/_search


# Get the exact total number of hits
GET enter_name_of_the_index_here/_search
{
  "track_total_hits": true
}

# Search for data within a specific time range
GET enter_name_of_the_index_here/_search
{
  "query": {
    "Specify the type of query here": {
      "Enter name of the field here": {
        "gte": "Enter lowest value of the range here",
        "lte": "Enter highest value of the range here"
      }
    }
  }
}

GET news_headlines/_search
{
  "query": {
    "range": {
      "date": {
        "gte": "2015-06-20",
        "lte": "2015-09-22"
      }
    }
  }
}

# Aggregations
 if you want to discover categories form given field?
 GET enter_name_of_the_index_here/_search
{
  "aggs": {
    "name your aggregation here": {
      "specify aggregation type here": {
        "field": "name the field you want to aggregate here",
        "size": state how many buckets you want returned here
      }
    }
  }
}

- pull up documents by categories, up to 100 docs
GET news_headlines/_search
{
  "aggs": {
    "by_category": {
      "terms": {
        "field": "category",
        "size": 100
      }
    }
  }
}

## Combine query and aggregation request

Example:
pull all docs from entertainment category
get summary of most frequent term in this selected document field eg. headline
THis way we can figure out what term is most used in given category/field

Search for the most significant term in a category

GET enter_name_of_the_index_here/_search
{
  "query": {
    "match": {
      "Enter the name of the field": "Enter the value you are looking for"
    }
  },
  "aggregations": {
    "Name your aggregation here": {
      "significant_text": {
        "field": "Enter the name of the field you are searching for"
      }
    }
  }
}

GET news_headline/_search
{
  "query": {
    "match": {
      "category": "ENTERTAINMENT"
    }
  },
  "aggregations": {
    "popular_in_entertainment": {
      "significant_text": {
        "field": "headline"
      }
    }
  }
}


