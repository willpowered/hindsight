class window.Popover extends View
  @content: (attach_element) ->
    @div class: 'popover'
  @show: (attach_element, el) ->
    x = new this()
    $('.popover, .backdrop').remove();
    x.appendTo 'body'
    setTimeout((->
      x.toggleClass 'visible'
      
      rect = attach_element[0].getBoundingClientRect()

      # position vertically
      x.css display: "block", top: rect.bottom + 20
      
      # position horizontally
      x.css left: "150px"
      
      # position nose
      ## not sure how to address :before in js

      x.show_backdrop()
      x.append(el)
    ), 0)
  show_backdrop: ->
    @back = document.createElement('div')
    @back.classList.add('backdrop')
    $(@back).on 'touchend click', =>
      @close()
    this.parent().append(@back)
  close: ->
    this.toggleClass('visible')
    setTimeout((=> this.remove()), 1000)
    @back.parentNode.removeChild(@back)

    
class window.Pager extends View
  @content: (root_element) ->
    @div class: 'pager_viewport'
  initialize: (root_element) ->
    this.append(root_element)
    @adjust_viewport()

  adjust_viewport: (el) ->
    console.log('adjusting viewport')
    el = this.children().last() unless el
    left = el[0].offsetLeft
    console.log('setting css', '-webkit-transform', "translateX(-#{left}px)")
    this.css('-webkit-transform', "translateX(-#{left}px)")
    
  push: (el) ->
    this.append(el)
    @adjust_viewport(el)
    return this
    # slide left of viewport over
  pop: ->
    this.children().last().remove()
    @adjust_viewport()
    return this
    # slide left of viewport to second to top
    # and remove the top

class window.Page extends View
  back: ->
    this.parents('.pager_viewport').view().pop()
    return false
  push: (el) ->
    this.parents('.pager_viewport').view().push(el)

class window.Modal extends View
  @show: (args...) ->
    x = new this(args...)
    x.appendTo 'body'
    setTimeout((-> x.toggleClass 'active'), 0)
  close: ->
    this.toggleClass('active')
    setTimeout((=> this.remove()), 1000)
values= (obj) ->
  return [] if !obj
  Object.keys(obj).map( (x) ->
    obj[x].id = x; return obj[x];
  )


class window.Typeahead extends View
  @content: (options) ->
    @form =>
      @input outlet: 'input', placeholder: options.hint, type: 'search'
      @button type: 'submit', class: 'not_there'
  initialize: (options) =>
    { suggestions, onchoose, onadded, renderer, hint } = options
    @sub this, 'submit', (ev) =>
      ev.preventDefault();
      onadded(@input.val())
      @input.typeahead('val', '')
      false
    @sub @input, 'typeahead:selected', (ev, data) =>
      if data.adder
        onadded data.name, this
      else
        onchoose data, this
      @input.typeahead('val', '')
    @input.typeahead({autoselect:true, minLength: 0},
      displayKey: 'name',
      source: (query, cb) =>
        cb(suggestions(query?.toLowerCase?()))
      templates:
        suggestion: renderer
    ,
      displayKey: 'name',
      source: (query, cb) =>
        cb([name: query, adder: true])
      templates:
        suggestion: renderer
    )
    @input.typeahead('val', '')



class window.Firecomplete extends Typeahead
  initialize: (params) ->
    @options = []
    @sub params.fb, 'value', (snap) =>
      @options = values(snap.val())
    params.suggestions = (q) =>
      return @options unless q
      return @options.filter (x) ->
        return x.name&&x.name.toLowerCase().indexOf(q) >= 0
    super(params)


class window.Fireahead extends View
  @content: (hint, fbref, cb) ->
    @form =>
      @input outlet: 'input', placeholder: hint, type: 'search', class: 'fireahead'
      @button type: 'submit', class: 'not_there'
  initialize: (hint, fbref, cb, add_choices) =>
    @options = []
    @sub fbref, 'value', (snap) =>
      @options = values(snap.val());
    @sub this, 'submit', (ev) =>
      ev.preventDefault();
      cb {typed: @input.val()}, this
      @input.typeahead('val', '')
      false
    @sub @input, 'typeahead:selected', (ev, data) =>
      cb(data, this)
      @input.typeahead('val', '')
    @input.typeahead({autoselect:true, minLength: 0},
      displayKey: 'name',
      source: (query, cb) =>
        q = query?.toLowerCase?()
        return cb(@options) unless q
        choices = @options.filter (x) ->
          return x.name&&x.name.toLowerCase().indexOf(q) >= 0
        return cb(add_choices(query)) if add_choices and not choices.length
        return cb(choices)
    )
    @input.typeahead('val', '')
