jQuery(document).ready ->
  jQuery('body').midgardCreate
    url: ->
      unless this.id
        return this.primaryCollection.url if this.primaryCollection
        return this.collection.url if this.collection
      this.getSubjectUri()
    workflows:
      url: (model) ->
        return "#{model.getSubjectUri()}/workflow"
    editorOptions:
      default:
        showAlways: true
        plugins:
          halloformat: {}
          hallolists: {}
          halloheadings: {}
          halloimage:
            uploadUrl: '/upload'
            search: (query, limit, offset, success) ->
              response =
                offset: offset
                total: limit + 1
                assets: []
              success response
