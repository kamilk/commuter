class CommuteForm
  constructor: () ->
    this.cars = ko.observableArray()
    this.users = ko.observableArray()
    this.finalData = ko.observable('')

    this.form = $(document.forms['new_commutes'])
    this.date = this.form.data('date')
    this.dataFetcher = new DataFetcher
    this.dataFetcher.fetchData(this.date, this.onDataFetched)

  getUserById: (id) ->
    for user in this.users()
      return user if user.id() == id

  # Event Handlers

  onFormSubmit: () ->
    this.finalData(JSON.stringify(this.getJsonData()))
    return true

  addCarEntry: () ->
    carEntry = new CarEntry(this)
    this.cars.push(carEntry)
    return carEntry

  removeCar: (car) =>
    this.cars.destroy(car)

  # Private Methods

  onDataFetched: () =>
    this.populateUsers()
    this.populateCommutes()

  populateUsers: () ->
    users = this.dataFetcher.getCommuters()
    return unless users?
    this.users.push(new User(user.id, user.name)) for user in users

  populateCommutes: () ->
    this.cars.removeAll()

    commutes = this.dataFetcher.getCommutes()
    if !commutes? || commutes.length == 0
      this.addCarEntry()
      return

    for commute in commutes
      car = this.addCarEntry()
      car.populate(commute)

  getJsonData: () ->
    data = {}
    data.date = this.date
    data.commutes = []
    for car in this.cars()
      data.commutes.push(car.getJsonData())
    return data
    
class CarEntry
  constructor: (parent) ->
    this.parent = parent
    this.driver = ko.observable()
    this.participations = ko.observableArray()
    this.advancedModeEnabled = ko.observable(false)

    for user in this.parent.users()
      this.participations.push(new Participation(this, user))

  # Event Handlers

  toggleMode: () ->
    this.switchMode(!this.advancedModeEnabled())

  getTemplateNameForParticipation: (participation) =>
    participation.getTemplateName()

  # Public Methods

  populate: (commute) ->
    this.driver(this.parent.getUserById(commute.driver))
    for participationData in commute.participations
      participation = this.getParticipationByUserId(participationData.user)
      participation.populate(participationData)

  getJsonData: () ->
    result = {
      driver: parseInt( this.driver().id() )
    }
    if this._destroy
      result.destroy = true
    else
      result.participations = this.getParticipationData()
    return result

  switchMode: (advanced) ->
    this.advancedModeEnabled(advanced)
    p.switchMode(this.advancedModeEnabled()) for p in this.participations()

  # Private Methods

  getParticipationByUserId: (id) ->
    for participation in this.participations()
      return participation if participation.user.id() == id

  getParticipationData: () ->
    participationData = []
    for participation in this.participations()
      data = participation.getJsonData()
      continue unless data?
      participationData.push(data)
    return participationData

class Participation
  constructor: (carEntry, user) ->
    this.carEntry = carEntry
    this.user = user
    this.isDriver = ko.computed(() =>
      this.carEntry.driver()? && this.carEntry.driver().id == this.user.id
    )
    this.isNotDriver = ko.computed(() => !this.isDriver())

    this.controller = ko.observable(new ParticipationSimple(this))

  # Public Methods

  populate: (data) ->
    if data.went_to != data.went_from
      this.carEntry.switchMode(true)
    this.controller().didGoTo(data.went_to)
    this.controller().didGoFrom(data.went_from)
    
  switchMode: (advanced) ->
    newController = if advanced
      new ParticipationAdvanced(this)
    else
      new ParticipationSimple(this)
    newController.didGo(this.controller().didGo())
    this.controller(newController)

  getJsonData: () ->
    return null unless this.controller().didGo()
    return {
      user_id: this.user.id()
      went_to: this.controller().didGoTo()
      went_from: this.controller().didGoFrom()
    }

  getTemplateName: () ->
    this.controller().getTemplateName()

class ParticipationSimple
  constructor: (participation) ->
    this.didGo = ko.observable(false).extend(blockedRead: {blocker: participation.isDriver})
    this.didGoTo = this.didGoFrom = this.didGo

  getTemplateName: () -> 'participation-simple-template'

class ParticipationAdvanced
  constructor: (participation) ->
    this.didGoTo = ko.observable(false).extend(blockedRead: {blocker: participation.isDriver})
    this.didGoFrom = ko.observable(false).extend(blockedRead: {blocker: participation.isDriver})
    this.didGo     = ko.computed(
      read: () => this.didGoTo() || this.didGoFrom()
      write: (value) =>
        this.didGoTo(value)
        this.didGoFrom(value)
    ).extend(blockedRead: {blocker: participation.isDriver})

  getTemplateName: () -> 'participation-advanced-template'

class User
  constructor: (id, name) ->
    this.id = ko.observable(id)
    this.name = ko.observable(name)

class DataFetcher
  constructor: () ->
    this.commutersFetched = false
    this.commutesFetched = false
  
  # Public Methods

  fetchData: (date, callback) ->
    this.callback = callback
    $.ajax(
      url: '/commuters',
      dataType: 'json'
    ).done(this.onCommutersFetched)

    $.ajax(
      url: '/commutes/' + date,
      dataType: 'json'
    ).done(this.onCommutesFetched)

  getCommutes: () -> this.commutes

  getCommuters: () -> this.commuters

  # Private Methods

  onCommutersFetched: (data) =>
    this.commutersFetched = true
    this.commuters = data
    this.notifyIfAllFetched()

  onCommutesFetched: (data) =>
    this.commutesFetched = true
    this.commutes = data
    this.notifyIfAllFetched()

  onUsersFetched: (data) =>
    this.usersFetched = true
    this.users = data
    this.notifyIfAllFetched()
  
  notifyIfAllFetched: () ->
    if this.commutersFetched && this.commutesFetched
      this.callback()

window.initCommuteForm = () ->
  ko.extenders.blockedRead = (target, options) ->
    ko.computed(
      read: () -> target() || options.blocker()
      write: (value) -> target(value)
    )

  commuteForm = new CommuteForm()
  window.commuteForm = commuteForm
  ko.applyBindings(commuteForm)
