# Export
module.exports = (BasePlugin) ->
	# Define
	class facebookRegisterPlugin extends BasePlugin
		# Name
		name: 'facebookregister'

		# Config
		config:
			extension: '.html'
			blockHtml: """
				<iframe src="https://www.facebook.com/plugins/registration?
		             client_id=113869198637480&
		             redirect_uri=https%3A%2F%2Fdevelopers.facebook.com%2Ftools%2Fecho%2F&
		             fields=name,birthday,gender,location,email"
			        scrolling="auto"
			        frameborder="no"
			        style="border:none"
			        allowTransparency="true"
			        width="100%"
			        height="330">
				</iframe>
				""".replace(/^\s+|\n\s*|\s+$/g,'')

		# Extend Template Data
		# Add our form to our template data
		extendTemplateData: ({templateData}) ->
			# Prepare
			{docpad,config} = @

			# getCommentsBlock
			templateData.getFacebookRegisterBlock = ->
				@referencesOthers()
				return config.blockHtml

			# Chain
			@


		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			# Prepare
			{server} = opts
			{docpad,config} = @
			database = docpad.getDatabase()
			
			ensureFbRegPage = ->	
				# Prepare
				docTitle = "facebook-register"
				filename = "#{docTitle}#{config.extension}"
				fileRelativePath = "login"
				fileFullPath = docpad.config.documentsPaths[0]+"/#{fileRelativePath}"

				# Facebook Register page data
				fbRegPageData = """
				---
				title: "#{docTitle}"
				layout: "default"
				---
				#{config.blockHtml}
				"""

				# Package attributes
				attributes =
					data: fbRegPageData
					filename: filename
					relativePath: fileRelativePath
					fullPath: fileFullPath

				# Create document from attributes
				fbRegPage = docpad.ensureDocument(attributes)

				# Load the document
				docpad.loadDocument fbRegPage, (err) ->
					# Check
					return err  if err

					# Add to the database
					database.add(fbRegPage)

					# Listen for regeneration
					docpad.once 'generateAfter', (err) ->
						# Check
						return err  if err

						# Update browser
						res.redirect('back')

					# Write source which will trigger the regeneration
					fbRegPage.writeSource (err) ->
						# Check
						return err  if err

			ensureFbRegPage()

			# Chain
			@