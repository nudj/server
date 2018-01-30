async function up ({ db, step }) {
  await step('Set Company.client boolean to false for all companies', async () => {
    const companiesCollection = db.collection('companies')
    const allCompanies = await companiesCollection.all()
    await allCompanies.each(company => companiesCollection.update(company, { client: false }))
  })

  await step('Set Hirer.onboarded boolean to all hirers', async () => {
    const hirersCollection = db.collection('hirers')
    const allHirersCursor = await hirersCollection.all()
    await allHirersCursor.each(hirer => hirersCollection.update(hirer, { onboarded: false }))
  })

  await step('Truncating surveys collection', async () => {
    const surveysCollection = db.collection('surveys')
    await surveysCollection.truncate()
  })

  await step('Create missing collections', async () => {
    await Promise.all([
      'surveySections',
      'surveyQuestions',
      'surveyAnswers',
      'connections',
      'roles',
      'sources'
    ].map(async name => {
      try {
        const collection = db.collection(name)
        await collection.create()
      } catch (error) {
        if (error.message !== 'duplicate name: duplicate name') {
          throw error
        }
      }
    }))
  })
}

async function down ({ db, step }) {
  await step('Remove Company.client boolean from all companies', async () => {
    const companiesCollection = db.collection('companies')
    const allCompanies = await companiesCollection.all()
    await allCompanies.each(company => companiesCollection.update(company, { client: null }, { keepNull: false }))
  })

  await step('Remove Hirer.onboarded boolean from all hirers', async () => {
    const hirersCollection = db.collection('hirers')
    const allHirersCursor = await hirersCollection.all()
    await allHirersCursor.each(hirer => hirersCollection.update(hirer, { onboarded: null }, { keepNull: false }))
  })

  await step('Truncating surveys collection', async () => {
    // cannot undo as is destructive so will just remove everything ready for a fresh import
    const surveysCollection = db.collection('surveys')
    await surveysCollection.truncate()
  })

  await step('Remove added collections', async () => {
    await Promise.all([
      'surveySections',
      'surveyQuestions',
      'surveyAnswers',
      'connections',
      'roles',
      'sources'
    ].map(async name => {
      try {
        const collection = db.collection(name)
        await collection.drop()
      } catch (error) {
        if (error.message !== `unknown collection '${name}'`) {
          throw error
        }
      }
    }))
  })
}

module.exports = { up, down }
