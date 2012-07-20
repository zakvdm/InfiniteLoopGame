
namespace "FNT", (exports) ->
  
  class exports.ObservableModel
    constructor: () ->
      @observers = []
      @ # return 'this'
  
    addObserver: (observer) ->
      @observers.push(observer)
      @
     
    ###  
     # Notify observers of a model event.
     #   The Event is an object with fields:
     #     eventType | eventData
     # @param eventType : a string indicating the event type
     # @param data an object with event data. Each event type will have its own data structure.
    ###
    notifyObservers: (eventType, eventData) ->
      observer.handleEvent {type: eventType, data: eventData} for observer in @observers
  
