const chai = require('chai')
const dirtyChai = require('dirty-chai')

const db = require('./db')
const { createDatabase, setupCollections, populateCollections } = require('./setup')
const { truncateCollections, teardownCollections, dropDatabase } = require('./teardown')

const { expect } = chai

chai.use(dirtyChai)

module.exports = {
  expect,
  db,
  createDatabase,
  setupCollections,
  populateCollections,
  truncateCollections,
  teardownCollections,
  dropDatabase
}
