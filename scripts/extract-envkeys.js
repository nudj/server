const npath = require('path')
const env = process.argv[2]
let path
switch (env) {
  case 'production':
  case 'staging':
  case 'demo':
    path = npath.join(__dirname, `../${process.argv[2]}/.env-api`)
    break
  default:
    path = npath.join(__dirname, `../../api/.env`)
}
require('dotenv').config({ path })
require('envkey')
const vars = process.env
const args = process.argv.slice(3)

console.log(args.map(envName => `${envName}=${vars[envName]}`).join(' '))
