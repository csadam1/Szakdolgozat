import { Server } from "socket.io";
import { Room } from "./handler.js";

const ROOM_SIZE = 2;
const io = new Server(3000);

io.on("connection", (socket) => {
    console.log("User connected", socket.id);

    socket.on("disconnect", async () => {
        await Room.deleteEmpty();
        console.log("User disconnected", socket.id);
    });

    socket.on("create-room", async (ack) => {
        try {
            // Már belépett egy szobába a kliens
            if ((await Room.isPlayerInRoom(socket.id)).length) {
                throw new Error("You are already in a room!");
            }
            
            const {id} = await Room.create(socket.id);
            socket.join(id);

            console.log("Room", id, "is created by", socket.id);
            ack({ status: "ok", roomId: id });
        } catch (e) {
            if (typeof ack === "function") {
                ack({ status: "error", message: e.message });
            }
        }
    });

    socket.on("join-room", async (id, ack) => {
        try {
            const allRooms = io.sockets.adapter.rooms;

            // Nincs ilyen szoba a socket.io szerverén
            if (!Array.from(allRooms.keys()).includes(id)) {
                throw new Error("This room does not exist!");
            }

            // Nincs ilyen szoba a memóriában (később db-ben)
            if (!await Room.contains(id)) {
                throw new Error("The given room id is incorrect!");
            }

            // Már a szobában van a kliens
            if (socket.rooms.has(id)) {
                throw new Error("The client is already in this room!");
            }

            // Már belépett egy szobába a kliens
            if ((await Room.isPlayerInRoom(socket.id)).length) {
                throw new Error("You are already in a room!");
            }

            // Tele van a szoba
            if (allRooms.get(id).size >= ROOM_SIZE) {
                throw new Error("The room is already full!");
            }

            // Már elindult a játék, a csatlakozás ezután nem lehetséges
            if ((await Room.find(id)).state === "locked") {
                throw new Error("The game is already started. You can not enter this room!");
            }

            socket.join(id);
            await Room.join(id, socket.id);

            const clients = await Room.getPlayers(id);
            clients.forEach((socketId, i) => {
                const player_ = (i % 2) ? "b" : "w";
                io.to(socketId).emit("room-is-full", player_);
            });

            console.log(socket.id, "joined room", id);
            ack({ status: "ok", roomId: id });
        } catch (e) {
            if (typeof ack === "function") {
                ack({ status: "error", message: e.message });
            }
        }
    });

    socket.on("leave-room", async (id, ack) => {
        try {
            // Nincs szobában a kliens
            if (id === 0) {
                throw new Error("The client is not in a room!");
            }

            // Nincs ilyen szoba a socket.io szerverén
            const allRooms = io.sockets.adapter.rooms;
            if (!Array.from(allRooms.keys()).includes(id)) {
                throw new Error("This room does not exist!");
            }

            // Nincs a szobában a kliens
            if (!socket.rooms.has(id)) {
                throw new Error("The client is not in this room.");
            }

            socket.leave(id);
            await Room.leave(socket.id, id);
            await Room.deleteEmpty();

            console.log(socket.id, "left room", id);
            ack({ status: "ok" });
        } catch (e) {
            if (typeof ack === "function") {
                ack({ status: "error", message: e.message });
            }
        }
    });

    socket.on("sync-action", async (id, action, ack) => {
        try {
            // Nincs szobában a kliens
            if (id === 0) {
                throw new Error("The client is not in a room!");
            }

            // Nincs ilyen szoba a socket.io szerverén
            const allRooms = io.sockets.adapter.rooms;
            if (!Array.from(allRooms.keys()).includes(id)) {
                throw new Error("This room does not exist!");
            }

            const clients = await Room.getPlayers(id);
            const reciever = clients.filter((id) => id !== socket.id)[0];
            io.to(reciever).emit("action-sent", action);

            console.log("Action is synced:", action);
            ack({ status: "ok" });
        } catch (e) {
            if (typeof ack === "function") {
                ack({ status: "error", message: e.message });
            }
        }
    });

    
    socket.on("send-message", async (id, message) => {
        try {
            // Nincs szobában a kliens
            if (id === 0) {
                throw new Error("The client is not in a room!");
            }

            // Nincs ilyen szoba a socket.io szerverén
            const allRooms = io.sockets.adapter.rooms;
            if (!Array.from(allRooms.keys()).includes(id)) {
                throw new Error("This room does not exist!");
            }

            io.in(id).emit('message', message);
            ack({ status: "ok" });
        } catch (e) {
            if (typeof ack === "function") {
                ack({ status: "error", message: e.message });
            }
        }
    })
});


// https://socket.io/docs/v4/rooms/

/**
 * Create room
 * Join room
 * Leave room
 * Sync action
 * Send message
 */
