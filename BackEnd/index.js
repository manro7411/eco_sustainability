const express = require('express');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const mysql = require('mysql');

const app = express();
const port = 3000;

app.use(bodyParser.json());

// Create MySQL connection
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '123',
  database: 'EF',
});
connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
    return;
  }
  console.log('Connected to MySQL database');
});
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const query = 'SELECT * FROM users WHERE username = ? AND password = ?';
  connection.query(query, [username, password], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    if (results.length > 0) {
      const user = {
        username: results[0].username,
        firstName: results[0].firstName, // Assuming 'firstName' is a column in the 'users' table
        lastName: results[0].lastName // Assuming 'lastName' is a column in the 'users' table
      };
      const token = jwt.sign(user, 'your-jwt-secret', { expiresIn: '1h' });
      res.json({ token: token, firstName: user.firstName, lastName: user.lastName });
    } else {
      res.status(401).json({ error: 'Invalid credentials' });
    }
  });
});

app.post('/register', (req, res) => {
  const { firstname, lastname, username, password } = req.body;
  console.log(req.body)

  const query = 'INSERT INTO users (firstname, lastname, username, password) VALUES (?, ?, ?, ?)';
  connection.query(query, [firstname, lastname, username, password], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    
    // Registration successful
    res.json({ success: true });
  });
});
app.post('/questions', (req, res) => {
  const { question,index, firstName, lastName} = req.body;
  console.log(req.body);

  const query = 'INSERT INTO questions (question,index_number,firstName,lastName) VALUES (?,?,?,?)';
  connection.query(query, [question,index, firstName, lastName], (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }

    // Question inserted successfully
    res.json({ message: 'Question added' });
  });
});

app.get('/questions', (req, res) => {
  const query = 'SELECT * FROM questions';

  connection.query(query, (error, results) => {
    if (error) {
      console.error('Error executing MySQL query:', error);
      res.status(500).json({ error: 'Internal server error' });
      return;
    }
    res.json(results);
  });
});
app.get('/sustain', (req, res) => {
  const query = 'SELECT p_name, p_cat, p_mat, p_price, p_decomp_time, p_pic FROM Sustain';

  // Execute the query
  connection.query(query, (err, rows) => {
    if (err) {
      console.error('Error executing the query: ', err);
      res.status(500).json({ error: 'Failed to fetch data from the database' });
      return;
    }

    // Send the retrieved data as a response
    res.json(rows);
  });
});

app.post('/comments', (req, res) => {
  const { comment, index, firstName, lastName } = req.body;
  console.log(req.body);
  
  // Insert the comment, index, firstName, and lastName into the MySQL database
  const query = 'INSERT INTO textcomments (comments, index_number, firstname, lastname) VALUES (?, ?, ?, ?)';
  connection.query(query, [comment, index, firstName, lastName], (err, result) => {
    if (err) {
      console.error('Error inserting comment:', err);
      res.status(500).send('Error inserting comment');
      return;
    }
    console.log('Comment inserted:', result);
    res.status(200).send('Comment inserted successfully');
  });
});

// Assuming you have the necessary dependencies and database connection already set up
app.get('/comments/:indexNumber', (req, res) => {
  const indexNumber = req.params.indexNumber;

  // Perform a database query to retrieve the comments based on the indexNumber
  connection.query(
    'SELECT * FROM textcomments WHERE index_number = ?',
    [indexNumber],
    (error, results) => {
      if (error) {
        console.error(error);
        res.status(500).json({ error: 'An error occurred' });
      } else {
        res.json(results);
      }
    }
  );
});




app.post('/logout', (req, res) => {
  res.json({ message: 'Logout successful' });
});
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
