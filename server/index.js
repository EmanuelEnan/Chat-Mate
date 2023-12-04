const { log } = require('console');
const express = require('express');
const { createServer } = require('http');
const { Server } = require('socket.io');

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

app.route('/').get((req, res) => {
    res.json('hello server');
})

io.on('connection', (socket) => {
    socket.join('anon-room')
    console.log('backend connected');
    socket.on('sendMsg', (msg) => {
        console.log('msg', msg);
        // socket.emit('sendMsgServer', { ...msg, type: 'othermsg' });
        io.to('anon-room').emit('sendMsgServer', { ...msg, type: 'othermsg' });
    })
})

httpServer.listen('3000');
