const Yeetcord = require("yeetcord.js");

const client = new Yeetcord.Client();

client.on("dab", message => {
  message.reply("No dabbing allowed");
  message.member.ban();
});

// again, obviously invalid token
client.login("Mzk1OTY5NjU0MjA1NDQ4MTky.XR43xg.jYhqbl4-IUcMT5z8sk-XFhg477E");
