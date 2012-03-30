jQuery(document).ready ->
  v = new VIE
  v.use new v.StanbolService
    proxyDisabled: true
    url : 'http://dev.iks-project.eu:8081'

  jQuery('body').midgardCreate
    vie: v
    url: ->
      if this.isNew()
        console.log this.primaryCollection, this.collection
        return this.primaryCollection.url if this.primaryCollection
        return this.collection.url if this.collection
      this.getSubjectUri()
    stanbolUrl: 'http://dev.iks-project.eu:8081'
    workflows:
      url: (model) ->
        return "#{model.getSubjectUri()}/workflow"
    editorOptions:
      default:
        showAlways: true
        plugins:
          halloformat: {}
          hallolists: {}
          halloblock: {}
          halloimage:
            uploadUrl: '/images/upload'
            search: (query, limit, offset, success) ->
              response =
                offset: offset
                total: limit + 1
                assets: []
              success response
          halloannotate:
            vie: v
