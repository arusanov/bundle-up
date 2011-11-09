Bundle up!
==========

Bundle up is a middleware for connect to manage all client-side assets in an organized way. Everything is manged using an assets file

    // assets.js
    module.exports = function(assets) {
    	assets.js.addFile(__dirname + "/public/js/jquery-1.6.4.min.js");
    	assets.js.addFile(__dirname + "/public/js/jquery.placeholder.min.js");
    	assets.js.addFile(__dirname + "/app/client/main.coffee");
    
    	assets.css.addFile(__dirname + "/public/bootstrap/bootstrap.min.css");
    	assets.css.addFile(__dirname + "/app/styles/screen.styl");
    }

Just point to a file (.js, .css, .coffee or .styl are currently supported) anywhere in your app directory. In your view you can then just render all the css or javascript files by calling `renderStyles` and `renderJs` like this:

    !!!
    html
      head
        != renderStyles
      body!= body
      != renderJs

By default this will render

    <link href='/bootstrap/bootstrap.min.css' media='screen' rel='stylesheet' type='text/css'/>
    <link href='/generated/app/styles/screen.css' media='screen' rel='stylesheet' type='text/css'/>

    <script src='/js/jquery-1.6.4.min.js' type='text/javascript'></script>
    <script src='/js/jquery.placeholder.min.js' type='text/javascript'></script>
    <script src='/generated/app/client/main.js' type='text/javascript'></script>


To render bundles `bundle:true` needs to be passed as a parameter to the middleware. This will concatenate all javascript and css files into bundles and render this:

    <link href='/generated/bundle/d7aa56c_global.css' media='screen' rel='stylesheet' type='text/css'/>
    <script src='/generated/bundle/1e4b515_global.js' type='text/javascript'></script>

All bundles are generated during startup. The filename will change with the content so you should configure your web server with far future expiry headers.

### generated/

All files that needs to be compiled, copied (if you are bundling up a file that doesn't reside in your `public/` directory) or bundled will end up in `public/generated/` directory. This is to have an organized way to separate whats actually *your code* and whats *generated code*.

Usage
-----

    app.use(new BundleUp(__dirname + "/assets", {
      staticRoot: __dirname + "/public/",
      staticUrlRoot:"/",
      bundle:true
    }));

The first parameter is the path to the assets file
