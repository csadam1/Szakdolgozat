import { io } from "socket.io-client";
import prompt from "prompt";

const socket = io("http://localhost:3000");
var roomId = 0;
var player = '';


prompt.start()

socket.on('connect', async () => {
  console.log('Connected to server!');
});

socket.on('disconnect', async () => {
  console.log('Lost connection to server!');
});


socket.on('room-is-full', async (player_) => {
  try {
    player = player_;
    console.log("The game is starting...");
  } catch (e) {
    console.log(e.message);
  }
});

socket.on('action-sent', async (action) => {
  try {
    console.log("Player's action:", action);
  } catch (e) {
    console.log(e.message);
  }
});

socket.on('message', async (message) => {
  try {
    console.log('>', message);
  } catch (e) {
    console.log(e.message);
  }
});

while (true) {
  const {cmd} = await prompt.get(['cmd']);

  switch (cmd) {
    case 'create-room':
      socket.emit('create-room', (res) => {
        console.log(res.status);
        if (res.status === 'ok') {
          roomId = res.roomId;
          console.log(res.roomId);
        } else {
          console.log(res.message);
        }
      });
      break;

    case 'join-room':
      const {roomId_} = await prompt.get(['roomId_']);

      socket.emit('join-room', parseInt(roomId_), (res) => {
        console.log(res.status);
        if (res.status !== 'ok') {
          console.log(res.message);
        } else {
          roomId = res.roomId;
        }
      });
      break;

    case 'leave-room':
      socket.emit('leave-room', parseInt(roomId), (res) => {
        roomId = 0;
        player = '';
        console.log(res.status);
        if (res.status !== 'ok') {
          console.log(res.message);
        }
      });
      break;

    case 'sync-action':
      const {action} = await prompt.get(['action']);

      socket.emit('sync-action', roomId, action, (res) => {
        console.log(res.status);
        if (res.status !== 'ok') {
          console.log(res.message);
        }
      });
      break;

    case 'send-message':
      const {message} = await prompt.get(['message']);

      socket.emit('send-message', roomId, message, (res) => {
        if (res.status !== 'ok') {
          console.log(res.message);
        }
      });
      break;

    default:
      break;
  }
}
/**
 * Room is full
 * Action sent
 * Message
 */