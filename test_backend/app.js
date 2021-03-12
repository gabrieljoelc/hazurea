const express = require('express');
const app = express();
const port = 3000;

app.post('/api/sms/send', async (req, res) => {

  try{
    const body = req.body;
    console.log("Input Arguments");
    console.log(JSON.stringify(body, null, 4));

    return res.json({
      internalId: "This is an internal Id"
    });
  }
  catch{
    //This is what hasura expects for error responses to give good feedback to the client
    res.status(400);
    return res.json({
      "message": "Server Error",
      "code": "500"
    });
  }
});

app.post('/uploadTrigger', async (req, res) => {
  const body = req.body;

  console.log("Trigger Body");
  console.log(JSON.stringify(body, null, 4));

  res.status(200);
  return res.send();
});

app.listen(port);