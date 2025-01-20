
## install
- docker
 https://github.com/LisaHJung/Part-1-Intro-to-Elasticsearch-and-Kibana/blob/main/docker-compose-directions.md

# Start kibana and elasticsearch 
use docker-compose-single.yml

docker-compose up -d

docker compose logs
docker compose ps

docker-compose down -v
docker-compose down



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


  Example:
  Import data from https://www.kaggle.com/datasets/rmisra/news-category-dataset using kibana FileVisualizer in Kibana/home/ingest section/fileUpload

  indexName: news_headline

# Basic search
  kibana/dev_console: 
  > GET news_headlines/_search


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

# Discover  what categories are there?
aggregation - is type of search to get summary about data

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
        "field": "category", # pull unique values form this field
        "size": 100 # limit values up to 100
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

GET news_headlines/_search
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


see stats: aggregations/popular_in_entertainment/buckets

show frequency of terms in this field

## Precision and Recall
doens't take proximity into account between terms
  order is not impotant

GET enter_name_of_index_here/_search
{
  "query": {
    "match": {
      "Specify the field you want to search": {
        "query": "Enter search terms"
      }
    }
  }
}

- find docs matching field "headline"
  match when at least one term is inluded
GET news_headlines/_search
{
  "query": {
    "match": {
      "headline": {
        "query": "Khloe Kardashian Kendall Jenner" # OR logic applied
      }
    }
  }
}

## ncreasing Precision
We can increase precision by adding an "and" operator to the query.

GET enter_name_of_index_here/_search
{
  "query": {
    "match": {
      "Specify the field you want to search": {
        "query": "Enter search terms",
        "operator": "and"
      }
    }
  }
}

GET news_headlines/_search
{
  "query": {
    "match": {
      "headline": {
        "query": "Khloe Kardashian Kendall Jenner",
        "operator": "and"
      }
    }
  }
}

- minimum_should_match

This parameter allows you to specify the minimum number of terms a document should have to be included in the search results.

This parameter gives you more control over fine tuning precision and recall of your search.

GET enter_name_of_index_here/_search
{
  "query": {
    "match": {
      "headline": {
        "query": "Enter search term here",
        "minimum_should_match": Enter a number here
      }
    }
  }
}

- at least 3 terms must match
  doens't take proximity into account between terms
  order is not impotant
GET news_headlines/_search
{
  "query": {
    "match": {
      "headline": {
        "query": "Khloe Kardashian Kendall Jenner",
        "minimum_should_match": 3
      }
    }
  }
}

# Matching query and match_phrase query - match_phrase
https://www.youtube.com/watch?v=lTI4wsQKilI&list=PL_mJOmq4zsHbcdoeAwNWuhEWwDARMMBta&index=11

- queries
https://github.com/LisaHJung/Part-3-Running-full-text-queries-and-combined-queries-with-Elasticsearch-and-Kibana?tab=readme-ov-file#full-text-queries

- filtering
- sponsored entity
- not-exacly match

!!!! you want to search for phrases...

GET news_headlines/_search
{
  "query": {
    "match": {
      "headline": {
        "query": "Shape of you"
      }
    }
  }
}

Searching for phrases using the match_phrase query
If the order and the proximity in which the search terms are found(i.e. phrases) are important in determining the relevance of your search, you use the match_phrase query.

GET Enter_name_of_index_here/_search
{
  "query": {
    "match_phrase": {  # see here
      "Specify the field you want to search": {
        "query": "Enter search terms"
      }
    }
  }
}

GET news_headlines/_search
{
  "query": {
    "match_phrase": {
      "headline": {
        "query": "Shape of You"
      }
    }
  }
}


# Multi-match query
Running a match query against multiple fields
search mutliple fields at the same time
The multi_match query runs a match query on multiple fields and calculates a score for each field. Then, it assigns the highest score among the fields to the document.

This score will determine the ranking of the document within the search results.

GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search terms here",
      "fields": [
        "List the field you want to search over",
        "List the field you want to search over",
        "List the field you want to search over"
      ]
    }
  }
}

GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search terms here",
      "fields": [
        "List the field you want to search over",
        "List the field you want to search over",
        "List the field you want to search over"
      ]
    }
  }
}

Example:
The following multi_match query asks Elasticsearch to query documents that contain the search terms "Michelle" or "Obama" in the fields headline, or short_description, or authors.

GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "Michelle Obama",
      "fields": [
        "headline",
        "short_description",
        "authors"
      ]
    }
  }
}


## Per-field boosting

Headlines mentioning "Michelle Obama" in the field headline are more likely to be related to our search than the headlines that mention "Michelle Obama" once or twice in the field short_description.

To improve the precision of your search, you can designate one field to carry more weight than the others.

This can be done by boosting the score of the field headline(per-field boosting). This is notated by adding a carat(^) symbol and number 2 to the desired field as shown below.


GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search terms",
      "fields": [
        "List field you want to boost^2",
        "List field you want to search over",
        "List field you want to search over"
      ]
    }
  }
}

Example: 
GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "Michelle Obama",
      "fields": [
        "headline^2",
        "short_description",
        "authors"
      ]
    }
  }
}


GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "party planning",
      "fields": [
        "headline^2",
        "short_description"
      ]
    }
  }
}
- see
https://github.com/LisaHJung/Part-3-Running-full-text-queries-and-combined-queries-with-Elasticsearch-and-Kibana?tab=readme-ov-file#full-text-queries

## improving precision with phrase type match
You can improve the precision of a multi_match query by adding the "type":"phrase" to the query.

The phrase type performs a match_phrase query on each field and calculates a score for each field. Then, it assigns the highest score among the fields to the document.

GET Enter_the_name_of_the_index_here/_search
{
  "query": {
    "multi_match": {
      "query": "Enter search phrase",
      "fields": [
        "List field you want to boost^2",
        "List field you want to search over",
        "List field you want to search over"
      ],
      "type": "phrase"
    }
  }
}

Using per field boosting, this query assigns a higher score to documents containing the phrase "party planning" in the field headline. The documents that include the phrase "party planning" in the field headline will be ranked higher in the search results.

GET news_headlines/_search
{
  "query": {
    "multi_match": {
      "query": "party planning",
      "fields": [
        "headline^2",
        "short_description"
      ],
      "type": "phrase"
    }
  }
}

The recall is much lower(6 vs 2846 hits) but every one of the hits have the phrase "party planning" in either the field headline or short_description or both.

# Combined Queries
There will be times when a user asks a multi-faceted question that requires multiple queries to answer.

For example, a user may want to find political headlines about Michelle Obama published before the year 2016.

This search is actually a combination of three queries:

Query headlines that contain the search terms "Michelle Obama" in the field headline.
Query "Michelle Obama" headlines from the "POLITICS" category.
Query "Michelle Obama" headlines published before the year 2016
One of the ways you can combine these queries is through a bool query.

The bool query retrieves documents matching boolean combinations of other queries.

With the bool query, you can combine multiple queries into one request and further specify boolean clauses to narrow down your search results.

There are four clauses to choose from:

must
must_not
should
filter

GET name_of_index/_search
{
  "query": {
    "bool": {
      "must": [
        {One or more queries can be specified here. A document MUST match all of these queries to be considered as a hit.}
      ],
      "must_not": [
        {A document must NOT match any of the queries specified here. It it does, it is excluded from the search results.}
      ],
      "should": [
        {A document does not have to match any queries specified here. However, it if it does match, this document is given a higher score.}
      ],
      "filter": [
        {These filters(queries) place documents in either yes or no category. Ones that fall into the yes category are included in the hits. }
      ]
    }
  }
}

## A combination of query and aggregation request

A bool query can help you answer multi-faceted questions. Before we go over the four clauses of the bool query, we need to first understand what type of questions we can ask about Michelle Obama.

Let's first figure out what headlines have been written about her.

One way to understand that is by searching for categories of headlines that mention Michelle Obama.

Syntax:
GET Enter_name_of_the_index_here/_search
{
  "query": {
    "Enter match or match_phrase here": { "Enter the name of the field": "Enter the value you are looking for" }
  },
  "aggregations": {
    "Name your aggregation here": {
      "Specify aggregation type here": {
        "field": "Name the field you want to aggregate here",
        "size": State how many buckets you want returned here
      }
    }
  }
}

The following query ask Elasticsearch to query all data that has the phrase "Michelle Obama" in the headline. Then, perform aggregations on the queried data and retrieve up to 100 categories that exist in the queried data.

GET news_headlines/_search
{
  "query": {
    "match_phrase": {
      "headline": "Michelle Obama"
    }
  },
  "aggregations": {
    "category_mentions": {
      "terms": {
        "field": "category",
        "size": 100
      }
    }
  }
}

## Must query
GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
        {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for" 
          }
        }
      ]
    }
  }
}

The following is a bool query that uses the must clause. This query specifies that all hits must match the phrase "Michelle Obama" in the field headline and match the term "POLITICS" in the field category.

GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "match_phrase": {
          "headline": "Michelle Obama"
         }
        },
        {
          "match": {
            "category": "POLITICS"
          }
        }
      ]
    }
  }
}


# The must_not clause
The must_not clause defines queries(criteria) a document MUST NOT match to be included in the search results.
GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
       "must_not":[
         {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ]
    }
  }
}


want all Michelle Obama headlines except for the ones that belong in the "WEDDINGS" category?

The following bool query specifies that all hits must contain the phrase "Michelle Obama" in the field headline. However, the hits must_not contain the term "WEDDINGS" in the field category

GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": {
        "match_phrase": {
          "headline": "Michelle Obama"
         }
        },
       "must_not":[
         {
          "match": {
            "category": "WEDDINGS"
          }
        }
      ]
    }
  }
}

# should clause 
The should clause adds "nice to have" queries(criteria). The documents do not need to match the "nice to have" queries to be considered as hits. However, the ones that do will be given a higher score so it shows up higher in the search results.

GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here: {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        },
       "should":[
         {
          "Enter match or match_phrase here": {
            "Enter the name of the field": "Enter the value you are looking for"
          }
        }
      ]
    }
  }

  GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "match_phrase": {
          "headline": "Michelle Obama"
          }
         }
        ],
       "should":[
         {
          "match_phrase": {
            "category": "BLACK VOICES"
          }
        }
      ]
    }
  }
}


## Filter clause
The filter clause contains filter queries that place documents into either "yes" or "no" category.

For example, let's say you are looking for headlines published within a certain time range. Some documents will fall within this range(yes) or do not fall within this range(no).

The filter clause only includes documents that fall into the yes category.


GET Enter_name_of_the_index_here/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "Enter match or match_phrase here": {
          "Enter the name of the field": "Enter the value you are looking for" 
         }
        }
        ],
       "filter":{
          "range":{
             "date": {
               "gte": "Enter lowest value of the range here",
               "lte": "Enter highest value of the range here"
          }
        }
      }
    }
  }
}


GET news_headlines/_search
{
  "query": {
    "bool": {
      "must": [
        {
        "match_phrase": {
          "headline": "Michelle Obama"
          }
         }
        ],
       "filter":{
          "range":{
             "date": {
               "gte": "2014-03-25",
               "lte": "2016-03-25"
          }
        }
      }
    }
  }
}

## Aggregation