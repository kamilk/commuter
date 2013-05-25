# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class CommuteForm
  constructor: () ->
    this.carEntries = []
    this.commuters = []

  init: () =>
    this.form = $(document.forms['new_commutes'])
    this.form.submit(this.onFormSubmit)

    this.dataField = this.form.find('[name=data]')

    this.carContainer = $('#cars-container')

    initialEntry = $('.commute-car-entry')
    this.entryPrototype = initialEntry.clone()

    this.addCarButton = $('#commute-add-car-button')
    this.addCarButton.click(this.onAddCarClicked)

    this.carEntries.push(new CarEntry(this, initialEntry))
    $.ajax(
      url: '/commuters',
      dataType: 'json'
    ).done(this.onCommutersFetched)

  onAddCarClicked: () =>
    newEntry = this.entryPrototype.clone()
    this.carContainer.append(newEntry)
    this.carEntries.push(new CarEntry(this, newEntry))

  onCommutersFetched: (data) =>
    this.commuters = data
    for car in this.carEntries
      car.updateCommuters()

  getCommuters: () -> this.commuters

  getJsonData: () ->
    data = []
    for car in this.carEntries
      data.push(car.getJsonData())
    return data

  onFormSubmit: () =>
    this.dataField.val(JSON.stringify(this.getJsonData()))

class CarEntry
  constructor: (parent, rootElement) ->
    this.parent = parent
    this.participations = []
    this.driverSelect = rootElement.find('.driver-select')
    this.commutersContainer = rootElement.find('.commuters-container')
    this.updateCommuters()

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

class Participation
  constructor: (commuter) ->
    this.commuter = commuter
    this.rootElement = $('<label class="checkbox"></label>')
    this.checkbox = $('<input type="checkbox">')
    this.rootElement.append(this.checkbox).append(document.createTextNode(commuter.name))

  getElement: () -> this.rootElement

  getJsonData: () ->
    return null unless this.checkbox.is(':checked')
    return {id: this.commuter.id}

commuteForm = new CommuteForm()
$(document).ready(commuteForm.init)
window.commuteForm = commuteForm
