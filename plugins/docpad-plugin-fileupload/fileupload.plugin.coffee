# Export
module.exports = (BasePlugin) ->
  # Define
	class fileuploadPlugin extends BasePlugin
		# Name
		name: 'fileupload'

		# Create Server and Express Application
		###
		express = require("express")
		http = require("http")
		app = express()

		# Add our Application Stuff
		app.use express.bodyParser()
		app.use express.methodOverride()
		app.use app.router

		# Add DocPad to our Application
		docpadInstanceConfiguration =
		  
		  # Give it our express application and http server
		  serverExpress: app
		  serverHttp: server
		  
		  # Tell it not to load the standard middlewares (as we handled that above)
		  middlewareStandard: false

		docpadInstance = require("docpad").createInstance(docpadInstanceConfiguration, (err) ->
		  return console.log(err.stack)  if err
		  
		  # Tell DocPad to perform a generation, extend our server with its routes, and watch for changes
		  docpad.action "generate server watch", (err) ->
		    console.log err.stack  if err

		)
		###

		# Config
		config:
			collectionName: 'files'
			relativePath: 'Uploads'
			postUrl: '/fileupload'
			blockUpload: """
				<section class="fileupload">
					<form action="#{postUrl}" method="post" enctype="multipart/form-data">
						<label for="file">Filename:</label>
						<input type="file" name="file" id="file" value="Upload"><br>
						<input type="submit" name="submit" value="Submit">
						</form>
				</section>
				""".replace(/^\s+|\n\s*|\s+$/g,'')

		# Extend Template Data
		# Add our form to our template data
		extendTemplateData: ({templateData}) ->
			# Prepare
			{docpad,config} = @

			# getCommentsBlock
			templateData.getUploadBlock = ->
				@referencesOthers()
				return config.blockUpload

			# getComments
			templateData.getUploadedFiles = ->
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
			uploadedFiles = database.findAllLive({relativePath: $startsWith: config.relativePath},[date:-1])

			# Set the collection
			docpad.setCollection(config.collectionName, uploadedFiles)

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
				date = new Date()
				dateTime = date.getTime()
				dateString = date.toString()
				filename = req.body.file
				fileRelativePath = "#{config.relativePath}/#{filename}"
				fileFullPath = docpad.config.documentsPaths[0]+"/#{fileRelativePath}"

				fileUploadPath = require('fileupload').createFileUpload('/Uploads')

				# file is an object with information about the uploaded file
				# See below for the contents of this object
				fileupload.put "#{fileFullPath}", (error, file) ->
				  if error
				    console.log error 
				            
				  ensureFile = docpad.ensureDocument("#{fileFullPath}") 
				  database.add(ensureFile)


						###
						# Listen for regeneration
						docpad.once 'generateAfter', (err) ->
							# Check
							return next(err)  if err
						
							# Update browser
							res.redirect('back')
						###

			# Done
			@


