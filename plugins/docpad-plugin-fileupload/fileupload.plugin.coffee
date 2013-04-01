# fs = require('fs')

# Export
module.exports = (BasePlugin) ->
  # Prepare
  	# uploadDir = @site?.uploadDir
	#fs.chmodSync('./', 0o0777)
  # Define
	class fileuploadPlugin extends BasePlugin
		# Name
		name: 'fileupload'

		# Config
		config:
			collectionName: 'uploads'
			relativePath: 'uploads'
			postUrl: '/uploads'
			blockUpload: """
				<section class="fileupload">
					<form action="/uploads" method="post" enctype="multipart/form-data">
						<label for="file">Filename:</label>
						<input type="file" name="fileInput" id="fileInput" value="Upload"><br>
						<input type="submit" name="submit" value="Upload">
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

			# getUploads
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
			uploads = database.findAllLive({relativePath: $startsWith: config.relativePath},[date:-1])

			# Set the collection
			docpad.setCollection(config.collectionName, uploads)

			# Chain
			@


		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			# Prepare
			{server} = opts
			{docpad,config} = @
			database = docpad.getDatabase()

			fileupload = require('fileupload').createFileUpload('/uploads') # .middlewear is called in the server.post as fileupload.middlewear 

			console.log "here"
			# Publish Handing
			server.post config.postUrl, fileupload.middleware, (req,res) ->
				console.log "there"
				console.log req.files
				fileLoaded = req.body
				database.add(fileLoaded)
				# Prepare


			# Done
			@
