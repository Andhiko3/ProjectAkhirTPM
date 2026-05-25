require('dotenv').config();

const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express();

app.use(express.json());
app.use(cors());

const db = mysql.createConnection({

    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
});

db.connect((err) => {

    if (err) {

        console.log(err);
    } else {

        console.log('MySQL Connected');
    }
});

app.get('/', (req, res) => {

    res.send('API Running');
});


// ======================
// REGISTER
// ======================

app.post('/register', async (req, res) => {

    const { username, password } = req.body;

    const hashedPassword =
        await bcrypt.hash(password, 10);

    const sql =
        'INSERT INTO users(username,password) VALUES (?,?)';

    db.query(
        sql,
        [username, hashedPassword],
        (err, result) => {

            if (err) {

                return res.status(500).json(err);
            }

            res.json({
                message: 'Register Success'
            });
        }
    );
});


// ======================
// LOGIN
// ======================

app.post('/login', (req, res) => {

    const { username, password } = req.body;

    const sql =
        'SELECT * FROM users WHERE username=?';

    db.query(sql, [username], async (err, result) => {

        if (err) {

            return res.status(500).json(err);
        }

        if (result.length === 0) {

            return res.status(401).json({
                message: 'User not found'
            });
        }

        const user = result[0];

        const validPassword =
            await bcrypt.compare(
                password,
                user.password
            );

        if (!validPassword) {

            return res.status(401).json({
                message: 'Wrong password'
            });
        }

        const token = jwt.sign(

            {
                id: user.id
            },

            process.env.JWT_SECRET
        );

        res.json({

            message: 'Login Success',
            token: token
        });
    });
});


app.listen(3000, () => {

    console.log('Server Running');
});