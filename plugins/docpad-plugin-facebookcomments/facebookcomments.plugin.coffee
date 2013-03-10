# Export
module.exports = (BasePlugin) ->
	# Define
	class facebookCommentsPlugin extends BasePlugin
		# Name
		name: 'facebookcomments'

		# Config
		config:
			extension: '.html'
			blockFbSDK: """
				<div id="fb-root"></div>
				<script>
				  window.fbAsyncInit = function() {
				    // init the FB JS SDK
				    FB.init({
				      appId      : '221359268009894', /* App ID from the App Dashboard */
				      channelUrl : '//localhost:9778/fb-comments.html', /* Channel File for x-domain communication */
				      status     : true, // check the login status upon init?
				      cookie     : true, // set sessions cookies to allow your server to access the session?
				      xfbml      : true  // parse XFBML tags on this page?
				    });

				    // Additional initialization code such as adding Event Listeners goes here

				  };

				  // Load the SDK's source Asynchronously
				  // Note that the debug version is being actively developed and might 
				  // contain some type checks that are overly strict. 
				  // Please report such bugs using the bugs tool.
				  (function(d, debug){
				     var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
				     if (d.getElementById(id)) {return;}
				     js = d.createElement('script'); js.id = id; js.async = true;
				     js.src = "//connect.facebook.net/en_US/all" + (debug ? "/debug" : "") + ".js";
				     ref.parentNode.insertBefore(js, ref);
				   }(document, /*debug*/ false));
				</script>
				"""
			blockFbCommentScript: """
				<div id="fb-root"></div>
				<script>(function(d, s, id) {
				  var js, fjs = d.getElementsByTagName(s)[0];
				  if (d.getElementById(id)) return;
				  js = d.createElement(s); js.id = id;
				  js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=221359268009894";
				  fjs.parentNode.insertBefore(js, fjs);
				}(document, 'script', 'facebook-jssdk'));</script>
				""".replace(/^\s+|\n\s*|\s+$/g,'')
			blockFbComments: """
				<div class="fb-comments" data-href="http://localhost:9778" data-width="470" data-num-posts="10"></div>
				""".replace(/^\s+|\n\s*|\s+$/g,'')

		# Extend Template Data
		# Add our form to our template data
		extendTemplateData: ({templateData}) ->
			# Prepare
			{docpad,config} = @

			# getFbSdkBlock
			templateData.getFbSdkBlock = ->
				@referencesOthers()
				return config.blockFbSDK

			# getScriptBlock
			templateData.getFbCommentScriptBlock = ->
				@referencesOthers()
				return config.blockFbCommentScript

			# getScriptBlock
			templateData.getFbCommentsBlock = ->
				@referencesOthers()
				return config.blockFbComments

			# Chain
			@

		scrapeFbComments = ->
			request = require("request")
			fbCommentUrl = "http://localhost:9778/fb-comments.html"
			
			#Tell the request that we want to fetch Published Google Doc, send the results to a callback function
			request
			  uri: fbCommentUrl
			, (err, response, body) ->

		    commentRequest_url = "https://graph.facebook.com/comments/?ids=" . fbCommentUrl;

		    commentRequests = file_get_contents(commentRequest_url);
