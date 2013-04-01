# By nexusIX http://pastebin.com/dEEz9CG1

module.exports = ({server,docpad}, callback) ->
	server.use (req,res,next) ->
		req.app.post '/:portal/upload-doc', (req, res) =>
			config = docpad.getConfig()
			date = new Date()
			file_id = date.getTime().toString()
			dest_dir = config.uploadDir + file_id
			dest = dest_dir + "/" + req.files.file.name
	
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