const { Database } = require('arangojs')
const db = new Database({
  url: 'http://db:8529'
})
const [, , migrationName, direction, dbUser, dbPassword] = process.argv

db.useDatabase('nudj')
db.useBasicAuth(dbUser, dbPassword)

const migration = require(`./${migrationName}`)

migration[direction]({ db })
