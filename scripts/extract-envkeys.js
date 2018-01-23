const path = require('path')
require('dotenv').config({
  path: path.join(__dirname, `../${process.argv[2]}/.env-api`)
})
require('envkey')
const env = process.env
const args = process.argv.slice(3)

console.log(args.map(envName => `${envName}=${env[envName]}`).join(' '))
