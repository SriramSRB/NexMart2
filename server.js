const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.static(path.join(__dirname, 'NexMart.html')));

app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'NexMart.html'));
});

app.listen(PORT, () => {
    console.log(`NexMart server running on port ${PORT}`);
});