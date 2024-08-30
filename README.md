# LmChlng

## Starting the server

1. Export environment variables
  `source .env.dev`

2. Install dependencies
  `mix deps.get`

3. Setup database
  `mix ecto.setup`

4. Start the server
  `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Run tests
  
`source .env.test && mix test`

## Overview

Document upload is handled via the phoenix live view locased at [`localhost:4000`](http://localhost:4000).

Once a file is uploaded a reference to the path is stored in the database, and an Oban job is created to parse the xml file.

Documents can be retrieved via the rest api, which uses JSONAPI.

### Retrieve a single document

`GET /api/documents/{id}`

### Retrieve all documents
Pagination not implemented.

`GET /api/documents`