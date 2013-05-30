class CommuteForm
  constructor: () ->
    this.carEntries = []
    this.commuters = []

  # Public Methods

  init: () =>
    this.form = $(document.forms['new_commutes'])
    this.form.submit(this.onFormSubmit)

    this.dataField = this.form.find('[name=data]')

    this.carContainer = $('#cars-container')

    initialEntry = $('.commute-car-entry')
    this.entryPrototype = initialEntry.clone()

    this.addCarButton = $('#commute-add-car-button')
    this.addCarButton.click(this.onAddCarClicked)

    this.dataFetcher = new DataFetcher
    this.dataFetcher.fetchData(this.form.data('date'), this.onDataFetched)

    this.carEntries.push(new CarEntry(this, initialEntry))

  getCommuters: () -> this.dataFetcher.getCommuters()

  # Private Methods

  onAddCarClicked: () =>
    this.addCarEntry()

  addCarEntry: () ->
    newEntryElement = this.entryPrototype.clone()
    this.carContainer.append(newEntryElement)
    newCarEntry = new CarEntry(this, newEntryElement)
    this.carEntries.push(newCarEntry)
    return newCarEntry

  removeAllCarEntries: () ->
    for car in this.carEntries
      car.destroy()
    this.carEntries = []

  getJsonData: () ->
    data = []
    for car in this.carEntries
      data.push(car.getJsonData())
    return data

  onFormSubmit: () =>
    this.dataField.val(JSON.stringify(this.getJsonData()))
  
  onDataFetched: () =>
    commutes = this.dataFetcher.getCommutes()
    if commutes? && commutes.length > 0
      this.removeAllCarEntries()
      for commute in commutes
        car = this.addCarEntry()
        car.updateCommuters()
        car.populate(commute)
    else
      car.updateCommuters() for car in this.carEntries

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
  
  notifyIfAllFetched: () ->
    if this.commutersFetched && this.commutesFetched
      this.callback()

class CarEntry
  constructor: (parent, rootElement) ->
    this.parent = parent
    this.rootElement = rootElement
    this.participations = []
    this.driverSelect = rootElement.find('.driver-select')
    this.commutersContainer = rootElement.find('.commuters-container')

  # Public Methods

  destroy: () -> this.rootElement.remove()

  updateCommuters: () ->
    for commuter in this.parent.getCommuters()
      this.driverSelect.append( $('<option></option>').attr('value', commuter.id).text(commuter.name))
      participation = new Participation(commuter)
      this.participations.push(participation)
      this.commutersContainer.append(participation.getElement())

  getJsonData: () ->
    participationData = []
    for participation in this.participations
      data = participation.getJsonData()
      continue unless data?
      participationData.push(data)

    return {
      driver: parseInt( this.driverSelect.val() )
      participations: participationData
    }

  populate: (commute) ->
    this.driverSelect.val(commute.driver)
    for participationData in commute.participations
      participation = this.getParticipationForUser(participationData.user)
      participation.check()
    
  # Private Methods

  getParticipationForUser: (userId) ->
    for participation in this.participations
      return participation if participation.getUserId() == userId

class Participation
  constructor: (commuter) ->
    this.commuter = commuter
    this.rootElement = $('<label class="checkbox"></label>')
    this.checkbox = $('<input type="checkbox">')
    this.rootElement.append(this.checkbox).append(document.createTextNode(commuter.name))

  # Public Methods

  getElement: () -> this.rootElement

  getUserId: () -> this.commuter.id

  check: () -> this.checkbox.prop('checked', true)

  getJsonData: () ->
    return null unless this.checkbox.is(':checked')
    return {user_id: this.commuter.id}

commuteForm = new CommuteForm()
$(document).ready(commuteForm.init)
window.commuteForm = commuteForm
