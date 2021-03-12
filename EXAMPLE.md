# Example Summary

To run these examples, run `docker-compose up -d` and all requests can be posted to `http://localhost:8080/v1/graphql` in Postman
as a `GraphQL` request.

Unless otherwise specified, set the `x-hasura-admin-secret` header to `testsecret` to make auth simpler.

## Triggers

This repo is set to up to showcase the features of Hasura that make it easy to integrate with traditional REST APIs

The `uploads` table will trigger a webhook to the endpoint.

All that needs to happen for this to be triggered is an insert to the `uploads` table.

The request body will look like:

```
mutation insertUploads($objects: [uploads_insert_input!]!) {
  insert_uploads(objects: $objects) {
    affected_rows
    returning {
      id
    }
  }
}
```

with a variables block of:

```
{
    "objects": [
        {
            "path": "<file_path>" # Doesn't have to be a real path
        }
    ]
}
```

This should then trigger the backend server which will just echo the logs.

The return the client will get is:

```
{
    "data": {
        "insert_uploads": {
            "affected_rows": 1,
            "returning": [
                {
                    "id": 1
                }
            ]
        }
    }
}
```

## Actions

The `sendSmsMessage` mutation is an action that will directly trigger the endpoint specified in the environment variable `SEND_MESSAGE_URL`.

A sample GraphQL request to trigger this HTTP call is:

```
mutation sendSmsMessageMutation($body: String!, $to: String!, $messagingServiceId: String!) {
    sendSms(arg1: {Body: $body, To: $to, messagingServiceId: $messagingServiceId}) {
        internalId
    }
}
```

with a variables block of:

```
{
    "body": "Hello There!",
    "to": "<phone>",
    "messagingServiceId": "<messaging service id (a twilio thing)>"
}
```

This request will return:

```
{
    "data": {
        "sendSms": {
            "internalId": "This is an internal Id"
        }
    }
}
```

## Auth (Keycloak integration)

See [here](https://github.com/httpsOmkar/keycloak-hasura-connector/tree/master/docs) for how to set up keycloak via the admin panel to work with the connector specified in this repo.

Steps:
1. Get an access token from keycloak - see this [official guide](https://developers.redhat.com/blog/2020/01/29/api-login-and-jwt-token-generation-using-keycloak/)
2. Once that is done, in your response you will want the JWT in the `access_token` field of the response
3. In your request to Hasura, use an `Authorization` header with `Bearer <JWT>` as the input
4. Based on the request you are running, you will either get access approved or access denied.

To test this out the user should get access denied for using the Hasura action.