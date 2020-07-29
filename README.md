# companies-stream: Journalistic tool for accessing and analysing Companies House data via R

This package includes:

- Access to real time updates from the UK Companies House streaming API
- Utility methods for parsing, analysis and visualisation
- A demo Shiny application

Some features are under development, please follow rest of documentation for current functionality.

## Intoduction

Companies House release a number of <a href="https://www.gov.uk/guidance/companies-house-data-products">data products</a>, including the <a href="http://download.companieshouse.gov.uk/en_output.html">Company Data Product</a>, a downloadable data snapshot containing basic company data of live companies on the register, in a CSV format, updated every month. Although it is a great source for journalists, it only lists data up to the last day of the previous month. The <a href="https://developer.companieshouse.gov.uk/api/docs/">main API</a> returns up-to-date records, but it is not designed for access to bulk data.

The newer <a href="https://developer.companieshouse.gov.uk/developer/applications">Companies House streaming API</a> returns a live stream of update events, which can then be used to update the CSV to the present day.

## How to stream

1. Set the working directory to the root of the project
```
setwd("~/R_Projects/companies-stream")
```

2. To access the <a href="https://developer-specs.companieshouse.gov.uk/streaming-api/guides/overview">Companies House Streaming API</a>, first <a href="https://developer.companieshouse.gov.uk/api/docs/index/gettingStarted/quickStart.html#createaccount">set up</a> a user account and create a key in the <a href="https://developer.companieshouse.gov.uk/developer/applications">Developer Hub</a> and store it as an evironment variable named <code>CH_STREAMING_API_KEY</code>. To do so via R, run:

```
Sys.setenv(CH_STREAMING_API_KEY = "your_api_key_here")
```

3. Each event returned by the /companies endpoint is assigned to a timepoint, which is then incremented by one for the next event. To get an idea of where the current timepoint values are, run
```
curl -XGET -H "Authorization: your_api_key_here" https://stream.companieshouse.gov.uk/companies
```
and note down the timepoint value of an event.

4. In the streaming_script.R, change the timepoint value to a lower value than the current timepoint. Due to the huge amount of events, the API can only go back a few days. Set the timeout and run the first line. The response is stored in a new file in the data folder.

At the moment this process is manual and assumes trial attempts to find the right request parameters. In a newsroom setting, the command could be run by a daily cron job, which would automatically store the last timepoint.


5. To parse the stored <a href="http://ndjson.org/">ndjson</a> events and transform them into a data frame for subsequent analyses, run the second command.

Parsing will fail if stream cut prematurely and an event transmission was not completed. Further work needs to be done to ensure resillience.



1. 

