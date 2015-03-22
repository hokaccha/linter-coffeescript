linterPath = atom.packages.getLoadedPackage('linter').path
Linter = require "#{linterPath}/lib/linter"
coffee = require 'coffee-script'

class LinterCoffeeScript extends Linter
  @syntax: ['source.coffee', 'source.litcoffee']

  linterName: 'coffeescript'

  lintFile: (filePath, callback) ->
    fs.readFile filePath, 'utf8', (err, data) =>
      return callback([]) if err

      try
        coffee.compile data
      catch err
        callback(@createErrorMessage err)

  createErrorMessage: (err) ->
    {first_line, first_column, last_line, last_column} = err.location

    lineStart = first_line + 1
    lineEnd = if last_line? then last_line + 1 else lineStart
    colStart = first_column + 1
    colEnd = if last_column? then last_column + 1 else lineCol

    return @createMessage({
      message: err.message
      line: lineStart
      lineStart: lineStart
      lineEnd: lineEnd
      col: colStart
      colStart: colStart
      colEnd: colEnd + 1
      error: true
    })

module.exports = LinterCoffeeScript
