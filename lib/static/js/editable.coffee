jQuery(document).ready ->
  jQuery('body').midgardCreate
    url: ->
      unless this.id
        return this.collection.url if this.collection
      this.getSubjectUri()
