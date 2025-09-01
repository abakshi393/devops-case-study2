// Version 2
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send(`
    <html>
      <head>
        <title>DevOps Case Study 2</title>
        <style>
          body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #eaeaea;
          }
          .card {
            background: #1e1e2f;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.5);
            text-align: center;
            max-width: 500px;
            width: 90%;
            animation: fadeIn 1s ease-in-out;
          }
          h1 {
            font-size: 2.5rem;
            color: #4fc3f7;
            margin-bottom: 10px;
          }
          h3 {
            font-size: 1.2rem;
            color: #aaa;
            margin-bottom: 20px;
          }
          p {
            font-size: 1rem;
            margin: 10px 0;
            color: #ddd;
          }
          ul {
            list-style: none;
            padding: 0;
          }
          ul li {
            background: #2a2a40;
            margin: 8px 0;
            padding: 10px;
            border-radius: 8px;
            font-weight: 500;
            color: #4fc3f7;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            transition: transform 0.2s;
          }
          ul li:hover {
            transform: scale(1.05);
            background: #33334d;
          }
          @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
          }
        </style>
      </head>
      <body>
        <div class="card">
          <h1>DevOps Case Study 2</h1>
          <h3>By Atharva Bakshi</h3>
          <p><strong>Description:</strong> Deploying a Node.js app</p>
          <p><strong>Skills Required:</strong></p>
          <ul>
            <li>Jenkins</li>
            <li>Docker</li>
            <li>Terraform</li>
            <li>Ansible</li>
            <li>Git</li>
          </ul>
        </div>
      </body>
    </html>
  `);
});

app.listen(port, '0.0.0.0', () => console.log(`App running on http://0.0.0.0:${port}`));


