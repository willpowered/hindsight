class window.Observations
  @types: ['satisfies', 'leadsto', 'trumps', 'drives']
  @set: (guy, x, rel, y, val) ->
    fb('observations/%/%/%/%', guy, x.id, rel, y.id).set val
    fb('observations/%/%/%/%', guy, y.id, @inverse(rel), x.id).set val
    for relationToRemove in @incompatible(rel)
      @unset(guy, x, relationToRemove, y)
  @unset: (guy, x, rel, y) ->
    fb('observations/%/%/%/%', guy, x.id, rel, y.id).remove()
    fb('observations/%/%/%/%', guy, y.id, @inverse(rel), x.id).remove()
  @inverse: (rel) ->
    if rel.match(/^what/) then rel.replace('what', '') else "what#{rel}"
  @incompatible: (rel) ->
    switch rel
      when 'satisfies'
        [ 'leadsto', 'trumps', 'whatsatisfies', 'whatdrives' ]
      when 'leadsto'
        [ 'satisfies', 'whatleadsto', 'whatdrives' ]
      when 'trumps'
        [ 'satisfies', 'whattrumps', 'whatdrives' ]
      when 'drives'
        [  'whatsatisfies', 'whatleadsto', 'trumps']
  @infixPhrase: (rel, val) ->
    return 'sucks for' if val < 0.5
    switch rel
      when 'leadsto'       then 'led to'
      when 'satisfies'     then 'works for'
      when 'whatdrives'    then 'trying for'
  @suffixPhrase: (rel, val) ->
    switch rel
      when 'whatleadsto'   then 'delivered'
      when 'whatsatisfies' then 'worked'
