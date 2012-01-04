cleaner = ///
  <http://viejs.org/ns/([a-z]+)>
///

idToSubject = (id, request) ->
  if request.method is 'POST'
    return "<#{request.url}#{id}>"
  "<#{request.url}>"

exports.fromJSONLD = (data) ->
  if data.length
    newData = []
    for item in data
      newData.push exports.fromJSONLD item
    return newData

  newData = {}
  for predicate, object of data
    cleaned = cleaner.exec predicate
    continue unless cleaned
    continue if typeof object is 'object'
    continue if typeof object is 'string' and object.substr(0, 1) is '<'
    newData[cleaned[1]] = object 
  newData

exports.toJSONLD = (data, request) ->
  if data.length
    newData = []
    for item in data
      newData.push exports.toJSONLD item, request
    return newData

  newData = {}
  for property, value of data
    continue if typeof value is 'function'
    continue if property is 'undefined'
    if property is 'id'
      newData['@subject'] = idToSubject value, request
      continue

    newData["<http://viejs.org/ns/#{property}>"] = value
  newData
