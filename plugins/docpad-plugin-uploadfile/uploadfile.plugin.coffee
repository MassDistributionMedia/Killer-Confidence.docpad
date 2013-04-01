fs = require('fs')

# Export
module.exports = (BasePlugin) ->
  # Define
	class uploadfilePlugin extends BasePlugin
		# Name
		name: 'uploadfile'

		# Config
		config:
			collectionName: 'uploads'
			relativePath: 'uploads'
			postUrl: '/uploads'
			blockUpload: """
				<section class="uploadfile">
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
			templateData.getUploadFileBlock = ->
				@referencesOthers()
				return config.blockUpload

			# Chain
			@

		
		# Server Extend
		# Add our handling for posting the comment
		serverExtend: (opts) ->
			{server} = opts
			{docpad,config} = @

			# Publish Handing
			server.post config.postUrl, (req,res) ->

				# config = docpad.getConfig()
				date = new Date()
				file_id = date.getTime().toString()
				dest_dir = @site?.uploadDir # + file_id
				dest = dest_dir + "/" # + req.files.file.name
				console.log req.files
		
				fs.mkdir dest_dir, () =>
					# read the file
					doc_content = fs.readFile req.files.file.path, (err, data) =>
						if not err
							fs.writeFile dest, data, (err) =>
								if not err
									res.writeHead(200, {'Content-Type': 'text/plain'})
									res.end("{'state' : true, 'id' : '" + file_id + "', 'name' :'" + file_id + "'}")
									# delete the original file
									fs.unlink(req.files.file.path)
									

			# Done
			@

