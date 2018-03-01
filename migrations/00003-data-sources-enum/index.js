async function up ({ db, step }) {
  await step('Convert Sources entities to DataSource enum items', async () => {
    const sourcesCollection = db.collection('sources')
    const sourcesAll = await sourcesCollection.all()
    const sourcesMap = await sourcesAll.reduce((sources, source) => Object.assign(sources, {
      [source._key]: source.name.toUpperCase()
    }), {})

    const connectionsCollection = db.collection('connections')
    const connectionsAll = await connectionsCollection.all()
    await connectionsAll.each(connection => connectionsCollection.update(connection, {
      source: sourcesMap[connection.source] || connection.source
    }))
  })

  await step('Archive Sources collection', async () => {
    try {
      const collection = db.collection('sources')
      await collection.rename('sourcesArchive')
    } catch (error) {
      if (error.message !== `cannot rename collection: duplicate name`) {
        throw error
      }
    }
  })
}

async function down ({ db, step }) {
  await step('Restore Sources collection', async () => {
    try {
      const collection = db.collection('sourcesArchive')
      await collection.rename('sources')
    } catch (error) {
      if (error.message !== `cannot rename collection: duplicate name`) {
        throw error
      }
    }
  })

  await step('Associate Connection.source\'s to Sources entities', async () => {
    const sourcesCollection = db.collection('sources')
    const sourcesAll = await sourcesCollection.all()
    const sourcesMap = await sourcesAll.reduce((sources, source) => Object.assign(sources, {
      [source.name.toUpperCase()]: source._key
    }), {})

    const connectionsCollection = db.collection('connections')
    const connectionsAll = await connectionsCollection.all()
    await connectionsAll.each(connection => connectionsCollection.update(connection, {
      source: sourcesMap[connection.source] || connection.source
    }))
  })
}

module.exports = { up, down }
