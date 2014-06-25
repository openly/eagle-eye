should = require 'should'

testDir =  __dirname + '/../'
Mock = require (testDir + 'mock')

Validator = require (testDir + '../src/plugins/validator')

suite "Validator Executor", (done) ->
  appMock = {}
  test "Valid Test Executor (Simple)", (done) ->
    validator = new Validator(appMock)
    rules = name:
      required: true

    values = name: "asdf"
    executor = validator.validateExecutor(rules, values)
    executor (err) ->
      should.not.exist err
      done()
      return

    return

  test "Invalid Test Executor (Simple)", (done) ->
    values = first_name: "asdf"
    rules = first_name:
      required: true
      length:
        min: 10
        max: 50

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      err.should.have.length 1
      done()
      return

    return

  test "Validate Email (valid)", (done) ->
    values = email: "email@email.com"
    rules = email:
      required: true
      email: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.not.exist err
      done()
      return

    return

  test "Validate Email (Invalid)", (done) ->
    values = email: "dummy"
    rules = email:
      required: true
      email: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.exist err
      done()
      return

    return

  test "Validate URL (valid)", (done) ->
    values = sample_url: "www.sample.com"
    rules = sample_url:
      required: true
      url: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.not.exist err
      done()
      return

    return

  test "Validate URL (Invalid)", (done) ->
    values = sample_url: "wwwdotsampledotcom"
    rules = sample_url:
      required: true
      url: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.exist err
      done()
      return

    return

  test "Validate Alphanumeric (valid)", (done) ->
    values = sample_alphanumeric: "asdf1234"
    rules = sample_alphanumeric:
      required: true
      alphanumeric: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.not.exist err
      done()
      return

    return

  test "Validate Alphanumeric (Invalid)", (done) ->
    values = sample_alphanumeric: "wwwdotsampledotcom_@#!"
    rules = sample_alphanumeric:
      required: true
      alphanumeric: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.exist err
      done()
      return

    return

  test "Validate Phone (valid)", (done) ->
    values = sample_number: "123-123-1234"
    rules = sample_number:
      required: true
      phone: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.not.exist err
      done()
      return

    return

  test "Validate Phone (Invalid)", (done) ->
    values = sample_number: "123-123-1234123"
    rules = sample_number:
      required: true
      phone: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.exist err
      done()
      return

    return

  test "Validate IP (valid)", (done) ->
    values = sample_ip: "123.123.123.123"
    rules = sample_ip:
      required: true
      ip: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.not.exist err
      done()
      return

    return

  test "Validate IP (Invalid)", (done) ->
    values = sample_ip: "123-123-1234123"
    rules = sample_ip:
      required: true
      ip: true

    validator = new Validator(appMock)
    exec = validator.validateExecutor(rules, values)
    exec (err) ->
      should.exist err
      done()
      return

    return

  return
