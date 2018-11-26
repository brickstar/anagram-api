# anagram-api
---
## Design Overview
When building this API I focused on Object Oriented design, performant and reusable Ruby, and providing developer empathy. I built the project with the idea that other developers could jump into the codebase and easily see how the system works. While perhaps a framework that is a little overkill, I chose to build this in Rails using PostgreSQL. I knew ActiveRecord would work well for this particular feature set and wanted to put my best foot forward. Next time building this I might use a lighter-weight framework like Sinatra with Redis as the main data store. Some edge cases considered: invalid limit and size parameters, words not found in the data store.
___
## Data Structure
There are two tables - Words and Anagrams. Words belong to Anagrams and Anagrams has many  Words. The Anagram has an attribute of "anagram" that functions as a lookup key for all associated words. The key is a set of letters sorted alphabetically that points to all valid words that contain this letter set (e.g. words "read, "dear", and "dare" all have the key "ader").
___
## Setup
```
$ clone this repository - git clone https://<YOURUSERNAME>@bitbucket.org/brickstar/anagram-api.git
$ cd anagram-api
$ bundle
$ rake db:{drop,create,migrate,seed}
$ rails s
```
**Note** - seeding the database is optional. The internal and external test suites will run without seeding. Seeding will provide 1/50th of the English dictionary for sample data to interact with through: http://localhost:3000. Base URL for Heroku: https://matts-anagram-api.herokuapp.com. Currently the Heroku dataset also contains 1/50th of the English dictionary.
___
## Testing
Run the internal test suite from root directory of the project with the command:
```$ rspec```
Run the external test suite by spinning up a server from the root directory:
    ``` $ rails s```
In a separate shell window run the external test file:
``` $ ruby anagram_test.rb```
___
## Versions
Rails 5.2.1
Ruby 2.4.1
___
## Performance
As I built this project and made changes, I would check runtimes from the Heroku logs. Below are 5 examples of actual run times for specific queries to the API. Runtime numbers are accurate if the Heroku dyno is already awake.

**Base url: ```https://matts-anagram-api.herokuapp.com```**

GET ```/words-analytics```
```
X-Runtimes:
0.022723
0.024680
0.029116
0.028791
0.018330
```
GET ```/anagrams/teal```
```
X-Runtimes:
0.080124
0.020433
0.028277
0.021079
0.016915
```
GET ```/anagrams/teal?limit=2```
```
X-Runtimes:
0.026110
0.021023
0.027955
0.021754
0.013616
```
GET ```/anagrams/teal?proper_nouns=false```
```
X-Runtimes:
0.045797
0.044534
0.032456
0.049999
0.032273
```
GET ```/word-group-size/size=5```
```
X-Runtimes:
0.020636
0.025218
0.032757
0.021218
0.019185
```
GET ```/word-group-size/size=2```
This is the slowest endpoint in the system and was refactored for better perfomance.
```
X-Runtimes:
0.187408
0.183534
0.160630
0.213210
0.191499
```
GET ```/words-with-most-anagrams```
```
X-Runtimes:
0.033919
0.024291
0.024303
0.019001
0.017257
```
GET ```/check-anagrams```
```
X-Runtimes:
0.002257
0.006030
0.006424
0.003071
0.002796
```
___
___
___
# **Endpoints**
___
## **GET requests**
---
#### **Get list of anagrams for a given word:**
* **Returns a JSON array of English-language words that are anagrams of the word passed in the URL.**
* **Supports an optional query param `limit=[integer]` that indicates the maximum number of results to return.**
* **Endpoint:** `/anagrams/:word`
* **Method:** `GET`
* **Optional Params:**
   `limit=[integer]`
   `proper_noun=[boolean]`
* **Success Response:**
  * **Status:** 200
##### Example:
`curl -i https://matts-anagram-api.herokuapp.com/anagrams/teal.json`
  ```json
{
    "word": "teal",
    "anagrams": [
                    "tale",
                    "tael",
                    "leat",
                    "late",
                    "laet",
                    "atle"
                ]
}
  ```
#### Get word analytics:
* **Endpoint:** `/words-analytics`
* **Method:** `GET`
* **Optional Params:** N/A
* **Success Response:**
  * **Status:** 200
##### Example:
`curl -i https://matts-anagram-api.herokuapp.com/words-analytics`
```json
{
    "total_word_count": 4667,
    "shortest_word": 2,
    "longest_word": 23,
    "avg_word_length": 9.58,
    "median_word_length": 9
}
```

#### Check if group of words are anagrams of each other:

* **Endpoint:** `/check-anagrams`
* **Method:** `GET`
* **Optional Params:** N/A
* **Data Params:** `"words": ["read", "dear", "dare"]`
* **Success Response:**
  * **Status:** 200
#####  Examples:
`curl -i "http://matts-anagram-api.herokuapp.com/check-anagrams?words\[\]=read&words\[\]=dare&words\[\]=dear"`

```json
{
    "anagrams?": true
}
```
`curl -i  "http://matts-anagram-api.herokuapp.com/check-anagrams?words\[\]=read&words\[\]=dare&words\[\]=dear&words=\[\]=xylophone"`
```json
{
    "anagrams?": false
}
```
#### Return set of words with most anagrams:

* **Endpoint:** `/words-with-most-anagrams`
* **Method:** `GET`
* **Optional Params:**
```proper_nouns=[boolean]```
* **Success Response:**
  * **Status:** 200
##### Example:
`curl -i http://localhost:3000/words-with-most-anagrams.json`
```json
{
    "anagrams_count": 7,
    "anagrams": [
                    [
                        "teal",
                        "tale",
                        "tael",
                        "leat",
                        "late",
                        "laet",
                        "atle"
                    ]
                ]
}
```

#### Return lists of anagrams by group size:
**Returns sets of anagrams greater than or equal to the specified size paramater, grouped by size.**
* **Endpoint** `/word-group-size`
* **Method:** `GET`
* **Optional Params:**
`size=[integer]`
`proper_nouns=[boolean]`
* **Success Response:**
  * **Status:** 200
##### Example:
`curl -i http://matts-anagram-api.herokuapp.com/word-group-size?size=5`
```json
[
    {
        "sets_of": 7,
        "anagrams": [
                        [
                            "teal",
                            "tale",
                            "tael",
                            "leat",
                            "late",
                            "laet",
                            "atle"
                        ]
                    ]
    },
    {
        "sets_of": 5,
        "anagrams": [
                        [
                            "scrae",
                            "scare",
                            "ceras",
                            "caser",
                            "carse"
                        ],
                        [
                            "slee",
                            "sele",
                            "seel",
                            "lees",
                            "else"
                        ],
                            ...
]
```
---
## **POST Requests**
---
#### Add new words to the data store:
* **Takes an array of words and adds them to the database**
* **Adds an anagram key for word**
* **Words and anagram keys are only added if they do not already exist in the database**
* **Endpoint:** `/words`
* **Method:** `POST`
* **Optional Params:** N/A
* **Success Response:**
  * **Status:** 201
* **Data Params**: `'{ "words": ["read", "dear", "dare"] }'`
##### Example:
`curl -X POST "http://localhost:3000/words?words\[\]=read&words\[\]=dare&words\[\]=dear"`
___
## **DELETE Requests**
**Note - URLs provided here are for localhost only as to preserve the Heroku database**
___
#### Delete a single word from the data store:

* **Endpoint** `/words/:word`
* **Method:** `DELETE`
* **Optional Params:** N/A
* **Success Response:**
  * **Status:** 200
##### Example:
`curl -i -X DELETE http://localhost:3000/words/read.json`

#### Delete a word and associated anagrams:
* **Deletes a single word and all asscociated anagrams**
* **Deletes anagram key for specified word**
* **Endpoint:** `/delete-anagrams-for-word/:word`
* **Method:** `DELETE`
* **Optional Params:** N/A
* **Success Response:**
  * **Status:** 204
##### Example:
`curl -i -X DELETE http://localhost:3000/delete-anagrams-for-word/teal.json`

#### Delete all words and anagram keys:
* **Deletes all data from data store**
* **URL** `/words`
* **Method:** `DELETE`
*  **URL Params** `N/A`
* **Success Response:**
  * **Status:** 204
##### Example:
`curl -i -X DELETE http://localhost:3000/words.json`

----
