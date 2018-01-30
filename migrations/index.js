const { Database } = require('arangojs')
const db = new Database({
  url: 'http://db:8529'
})
const [migrationName, direction, dbUser, dbPassword] = process.argv.slice(2)

db.useDatabase('nudj')
db.useBasicAuth(dbUser, dbPassword)

const migration = require(`./${migrationName}`)

async function step (description, actions) {
  process.stdout.write(description)
  await actions()
  process.stdout.write(' 👍\n')
}

(async () => {
  try {
    await migration[direction]({ db, step })
  } catch (error) {
    console.log('\n\n', error)
  }
})()
