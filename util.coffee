module.exports =
  format: (txt)->
    txt.replace /\*/gm, "\u0002"
