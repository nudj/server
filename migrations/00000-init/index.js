async function up ({ db }) {
  process.stdout.write('Add Hirer.onboarded boolean to all hirers')
  const hirersCollection = db.collection('hirers')
  const allHirersCursor = await hirersCollection.all()
  await allHirersCursor.each(hirer => hirersCollection.update(hirer, { onboarded: false }))
  process.stdout.write(' 👍\n')

  process.stdout.write('Truncating surveys collection')
  const surveysCollection = db.collection('surveys')
  await surveysCollection.truncate()
  process.stdout.write(' 👍\n')
}

function down ({ db }) {
  console.log('down')
}

module.exports = { up, down }
