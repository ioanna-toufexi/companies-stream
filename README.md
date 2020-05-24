companies-stream: Access to Companies House streaming API via R
---------

This package includes a series of functions that give R users access to Companies House&#39;s <a href="https://developer.companieshouse.gov.uk/developer/applications">Streaming API</a>, as well as a tool that parses the <a href="http://ndjson.org/">ndjson</a> events and transforms them into R data frames, which can then be used in subsequent analyses.

To access the <a href="https://developer-specs.companieshouse.gov.uk/streaming-api/guides/overview">Companies House Streaming API</a>, create a key in the <a href="https://developer.companieshouse.gov.uk/developer/applications">Developer Hub</a> and store it as an evironment variable named CH_STREAMING_API_KEY. To do so via R, run:

```
Sys.setenv(CH_STREAMING_API_KEY = "your_api_key_here")
```