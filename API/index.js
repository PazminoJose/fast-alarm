const express = require('express');
const app = express();
app.use(express.json());
app.use("/api", require("./routes/app.routes"));

app.listen(process.env.port || 4000, function () {
    console.log("Listo para empezar")
})