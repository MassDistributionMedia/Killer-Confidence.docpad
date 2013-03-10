		
		# Config
		config:
			postUrl: '/deleteComment'	
			collectionName: 'gDocs'
			relativePath: 'gDocs'	

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
				commentTitle = req.body.title
				filename = "#{commentTitle}#{config.extension}"
				fileRelativePath = "#{config.relativePath}/#{filename}"
				fileFullPath = docpad.config.documentsPaths[0]+"/#{fileRelativePath}"

				# Extract Url
				gDocUri = req.body.gDocUrl or ''
				docFor = req.body.for or ''

					# Package attributes
					attributes =
						data: gDocData
						date: date
						filename: filename
						relativePath: fileRelativePath
						fullPath: fileFullPath

					# Load the document
					docpad.loadDocument gDoc, (err) ->
						# Check
						return next(err)  if err

						var musketeers = database.where({job: "Musketeer"});
						# Add to the database
						database.remove(gDoc)

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
 #------------------------------------------------- Sam !

				###
				Module dependencies.
				###
				cheerio = require("cheerio")
				request = require("request")				
				
				#Tell the request that we want to fetch Published Google Doc, send the results to a callback function
				request
				  uri: gDocUri
				, (err, response, body) ->
				#  self = this
				#  self.items = new Array() #I feel like I want to save my results in an array
				    
					  #Just a basic error check
					  console.log err
					    
					  #Use jQuery just as in any regular HTML page 
					    
					  $ = cheerio.load(body)
					  $body = $(body)
					 # $contents = $("#contents")
					  console.log "request" + $body
					  gCons($body)

			# Done
			@
