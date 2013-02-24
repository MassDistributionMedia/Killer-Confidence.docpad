var gDocData;

Sync(function() {
  var contents, reqCont;
  return reqCont = request.sync({
    uri: gDocUri
  }, contents = function(err, response, body) {
    var $, $contents;
    if (err && response.statusCode !== 200) {
      console.log("Request error.");
    }
    $ = cheerio.load(body);
    return $contents = $("#contents");
  });
});

gDocData = "---\ntitle: \"" + docTitle + "\"\nurl: \"" + gDocUri + "\"\nlayout: \"default\"\ndate: \"" + (date.toISOString()) + "\"\n---\n" + $contents;
