const Random = {
    usedSlots: [],
    min: 1000,
    max: 9999,
    generate: async function() {
        var rand;
        do {
            rand = Math.floor(Math.random() * (this.max - this.min + 1) + this.min);
        } while (this.usedSlots.includes(rand));
        this.usedSlots.push(rand)
        return rand;
    }
}

export const Room = {
    list: [],

    create: async function (userId) {
        this.list.push({
            id: await Random.generate(),
            players: [userId],
            state: "open"
        });
        return this.list[this.list.length-1];
    },

    join: async function (roomId, userId) {
        (await this.find(roomId))
            .players
            .push(userId);
        (await this.find(roomId)).state = "locked";
    },

    find: async function (roomId) {
        return this.list.filter((room) => room.id == roomId)[0];
    },

    contains: async function (id) {
        return this.list
            .map((room) => room.id)
            .includes(id);
    },

    deleteEmpty: async function () {
        this.list = this.list.filter((room) => room.players.length !== 0);
    },

    leave: async function (player, from) {
        (await this.find(from)).players = (await this.find(from)).players
            .filter((id) => id !== player);
    },

    getPlayers: async function (roomId) {
        return (await this.find(roomId)).players;
    },

    isPlayerInRoom: async function (id) {
        return this.list.filter((room) => room.players.includes(id));
    }
}

/* Room structure in DB {
    id: Int,
    players: [String, String],
    state: String
}*/