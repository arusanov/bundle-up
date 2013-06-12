AssetsManager = require './assets_manager'
Js = require './js'
Css = require './css'
OnTheFlyCompiler = require './otf_compiler'
compilers = require './default_compilers'
rimraf = require 'rimraf'

class BundleUp
  constructor: (app, assetPath, options = {bundle:false}) ->
    unless options.compilers?
      options.compilers = compilers
    else
      options.compilers.stylus = options.compilers.stylus || compilers.stylus
      options.compilers.coffee = options.compilers.coffee || compilers.coffee
      options.compilers.js = options.compilers.js || compilers.js
      options.compilers.css = options.compilers.css || compilers.css

    options._exec = process.env.bundle_exec or undefined # Used by the BundleUp-executeable
    options.minifyCss = options.minifyCss || false
    options.minifyJs = options.minifyJs || false

    @app = app
    @js = new Js(options)
    @css = new Css(options)

    require(assetPath)(new AssetsManager(@css, @js))

    if options.bundle or options._exec == 'build'
      if options._exec == 'build'
        measure = new Date
        rimraf.sync "#{options.staticRoot}/generated"

      @js.toBundles()
      @css.toBundles()
      if options._exec == 'build'
        console.log " - BundleUp: Assets successfully built (completed in #{new Date - measure}ms)!"
        process.exit()
    else
      # Compile files on-the-fly when not bundled
      @app.use (new OnTheFlyCompiler(@js, @css, options.compilers)).middleware

    @app.locals(
      renderStyles: (namespace=@css.defaultNamespace) =>
        return @css.render(namespace)
      renderJs: (namespace=@js.defaultNamespace) =>
        return @js.render(namespace)
    )

module.exports = (app, assetPath, options)->
  new BundleUp(app, assetPath, options)
