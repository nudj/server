require('envkey')
const { Database } = require('arangojs')

const url = `http://${process.env.DB_HOST}:${process.env.DB_PORT}`
const db = new Database({ url })
db.useDatabase(process.env.DB_NAME)
db.useBasicAuth(process.env.DB_USER, process.env.DB_PASS)

async function removeAllCollections () {
  const collections = await db.collections()
  await Promise.all(collections.map(async collection => {
    try {
      await collection.drop()
    } catch (error) {
      if (!error.message.startsWith('unknown collection')) {
        throw error
      }
    }
  }))
}

removeAllCollections()
