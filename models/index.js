if (!global.hasOwnProperty('db')) {
  var Sequelize = require('sequelize')
    , sequelize = null

  if (process.env.DATABASE_URL) {
    // the application is executed on Heroku ... use the postgres database
    var match = process.env.DATABASE_URL.match(/postgres:\/\/([^:]+):([^@]+)@([^:]+):(\d+)\/(.+)/)

    sequelize = new Sequelize(match[5], match[1], match[2], {
      dialect:  'postgres',
      protocol: 'postgres',
      port:     match[4],
      host:     match[3],
      logging:  true //false
    })
  } else {
    // the application is executed on the local machine ... use mysql
    sequelize = new Sequelize('jenelle', null, null, {
      dialect:  'postgres',
      protocol: 'postgres',
      host:     'localhost',
      port: 5432,
      logging:  true
    })
  }

  global.db = {
    Sequelize: Sequelize,
    sequelize: sequelize,
    Post:      sequelize.import(__dirname + '/post')
  }
}

module.exports = global.db