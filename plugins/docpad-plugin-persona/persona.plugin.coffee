# Export
module.exports = (BasePlugin) ->
	# Define
	class personaPlugin extends BasePlugin
		# Name
		name: 'persona'

		# Config
		config:
			postUrl: '/auth'
			blockClientSript: """
				<!-- Mozilla Persona start -->
				<script src="https://login.persona.org/include.js"></script>
				<script type="text/javascript">
				var signinLink = document.getElementById('signin');
				if (signinLink) {
				  signinLink.onclick = function() { navigator.id.request(); };
				}
				 
				var signoutLink = document.getElementById('signout');
				if (signoutLink) {
				  signoutLink.onclick = function() { navigator.id.logout(); };
				}

				var currentUser = 'mikeumus@gmail.com';
				 
				navigator.id.watch({
				  loggedInUser: currentUser,
				  onlogin: function(assertion) {
				    // A user has logged in! Here you need to:
				    // 1. Send the assertion to your backend for verification and to create a session.
				    // 2. Update your UI.
				    $.ajax({ /* <-- This example uses jQuery, but you can use whatever you'd like */
				      type: 'POST',
				      url: '/auth', // This is a URL on your website.
				      data: {assertion: assertion},
				      success: function(res, status, xhr) { window.location.reload(); },
				      error: function(xhr, status, err) {
				        navigator.id.logout();
				        alert("Login failure: " + err);
				      }
				    });
				  },
				  onlogout: function() {
				    // A user has logged out! Here you need to:
				    // Tear down the user's session by redirecting the user or making a call to your backend.
				    // Also, make sure loggedInUser will get set to null on the next page load.
				    // (That's a literal JavaScript null. Not false, 0, or undefined. null.)
				    $.ajax({
				      type: 'POST',
				      url: '/auth/logout', // This is a URL on your website.
				      success: function(res, status, xhr) { window.location.reload(); },
				      error: function(xhr, status, err) { alert("Logout failure: " + err); }
				    });
				  }
				});
				</script>
				<!-- Mozilla Persona end -->	
				""".replace(/^\s+|\n\s*|\s+$/g,'')
			blockLogin: """
				<a href="#" id="signin"> Login </a>
                <a href="#" id="signout"> Logout </a>
            	""".replace(/^\s+|\n\s*|\s+$/g,'')

		# Extend Template Data
		# Add our form to our template data
		extendTemplateData: ({templateData}) ->
			# Prepare
			{docpad,config} = @

			# getCommentsBlock
			templateData.getPersonaScriptBlock = ->
				@referencesOthers()
				return config.blockClientSript

			# Chain
			@


		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			# Prepare
			{server} = opts
			{docpad,config} = @
			database = docpad.getDatabase()

			# Publish Handing
			server.post config.postUrl, (req,res,next) ->

				# Prepare
				if req.body.assertion
				  https = require("https")
				  querystring = require("querystring")
				  data = querystring.stringify(
				    assertion: req.body.assertion
				    audience: "localhost:9778"
				  )
				  options =
				    hostname: "verifier.login.persona.org"
				    port: 443
				    path: "/verify"
				    method: "POST"
				    headers:
				      "Content-Type": "application/x-www-form-urlencoded"
				      "Content-Length": data.length

				  serverreq = https.request(options, (serverres) ->
				    console.log "statusCode: ", serverres.statusCode
				    console.log "headers: ", serverres.headers
				    bits = ""
				    serverres.on "data", (d) ->
				      bits += d

				    serverres.on "end", ->
				      hmmm = JSON.parse(bits)
				      console.log(bits);
				      if hmmm.status is "okay"
				        if hmmm.email is "mikeumus@gmail.com"
				          res.writeHead 200,
				            "Set-Cookie": "mycookie=verified"
				            "Content-Type": "text/plain"


				  )
				  serverreq.write data
				  serverreq.end()
				  serverreq.on "error", (e) ->
				    console.error e


			# Done
			@
