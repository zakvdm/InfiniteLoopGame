
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
     # @param eventData an object with event data. Each event type will have its own data structure.
     # @param eventSource the object firing the event
    ###
    notifyObservers: (eventType, eventData, eventSource = @) ->
      observer.handleEvent {type: eventType, data: eventData, source: eventSource} for observer in @observers
  
