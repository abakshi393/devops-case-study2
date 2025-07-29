const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>Nodejs App: Case study 2</title>
        <style>
          body {
            background-color: white;
            color: blue;
            font-family: Arial, sans-serif;
            text-align: center;
            padding: 50px;
          }
          h1 {
            font-size: 2.5rem;
          }
          p {
            font-size: 1.2rem;
          }
        </style>
      </head>
      <body>
        <h1>Nodejs App: Case study 2</h1>
        <p>by Atharva Bakshi</p>
      </body>
    </html>
  `);
});

app.listen(port, () => console.log(`App running on http://localhost:${port}`));

