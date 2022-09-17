let data = require("fs").readFileSync(require('path').join(__dirname,'..','entrega-1','tabelao.csv'), "utf8")
data = data.split("\r\n")
const obj = data.map(line=>{
    const rowArray = line.split(';')
    console.log(rowArray)
    
})
console.log(data)