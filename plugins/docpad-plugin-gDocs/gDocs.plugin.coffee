# Export
module.exports = (BasePlugin) ->
	# Define
	class gDocsPlugin extends BasePlugin
		# Name
		name: 'gDocs'

		# Config
		config:
			collectionName: 'gDocs'
			relativePath: 'gDocs'
			postUrl: '/newGoogleDoc'
			extension: '.html'
			blockHtml: """
				<section class="gDocs-section">

					<div class="gDoc-new">
						<h2>New Page</h2>

						<form action="/newGoogleDoc" method="POST">
							<input type="hidden" name="for" value="<%= @document.id %>" />
							<input type="text" placeholder="Title" name="title" /> <br/>
							<input type="url" placeholder="gDocs url" name="gDocUrl" /> <br/>
							<input type="submit" class="btn" value="Publish" />
						</form>
					</div>

				</section>
				""".replace(/^\s+|\n\s*|\s+$/g,'')

		# Extend Template Data
		# Add our form to our template data
		extendTemplateData: ({templateData}) ->
			# Prepare
			{docpad,config} = @

			# getCommentsBlock
			templateData.getGoogleDocsBlock = ->
				@referencesOthers()
				return config.blockHtml

			# getComments
			templateData.getGoogleDocs = ->
				return docpad.getCollection(config.collectionName).findAll(for:@document.id)

			# Chain
			@


		# Extend Collections
		# Create our live collection for our comments
		extendCollections: ->
			# Prepare
			{docpad,config} = @
			database = docpad.getDatabase()

			# Create the collection
			gDocs = database.findAllLive({relativePath: $startsWith: config.relativePath},[date:-1])

			# Set the collection
			docpad.setCollection(config.collectionName, gDocs)

			# Chain
			@


		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			# Prepare
			{server} = opts
			{docpad,config} = @
			database = docpad.getDatabase()

			# Comment Handing
			server.post config.postUrl, (req,res,next) ->
				# Prepare
				date = new Date()
				dateTime = date.getTime()
				dateString = date.toString()
				docTitle = req.body.title or "#{dateString}"
				filename = "#{docTitle}#{config.extension}"
				fileRelativePath = "#{config.relativePath}/#{filename}"
				fileFullPath = docpad.config.documentsPaths[0]+"/#{fileRelativePath}"

				# Extract Url
				gDocUri = req.body.gDocUrl or ''
				commentFor = req.body.for or ''

				###
				Module dependencies.
				###
				cheerio = require("cheerio")
				request = require("request")
				
				#Tell the request that we want to fetch youtube.com, send the results to a callback function
				request
				  uri: gDocUri
				, (err, response, body) ->
				#  self = this
				#  self.items = new Array() #I feel like I want to save my results in an array
				    
				  #Just a basic error check
				  console.log "Request error."  if err and response.statusCode isnt 200
				    
				  #Use jQuery just as in any regular HTML page 
				    
				  $ = cheerio.load(body)
				  $body = $("body")
				  $contents = $("#contents")
				  return $contents
				  
				# Comment data
				gDocData = """
					---
					title: "#{docTitle}"
					url: "#{gDocUri}"
					layout: "default"
					date: "#{date.toISOString()}"
					---
					#{$contents}
					"""

				# Package attributes
				attributes =
					data: gDocData
					date: date
					filename: filename
					relativePath: fileRelativePath
					fullPath: fileFullPath

				# Create document from attributes
				gDoc = docpad.ensureDocument(attributes)

				# Load the document
				docpad.loadDocument gDoc, (err) ->
					# Check
					return next(err)  if err

					# Add to the database
					database.add(gDoc)

					# Listen for regeneration
					docpad.once 'generateAfter', (err) ->
						# Check
						return next(err)  if err

						# Update browser
						res.redirect('back')

					# Write source which will trigger the regeneration
					gDoc.writeSource (err) ->
						# Check
						return next(err)  if err


			# Done
			@
