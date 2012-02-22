(function() {
  var fs, jade, path, stitch, util, _;

  stitch = require('stitch');

  jade = require('jade');

  fs = require('fs');

  util = require('util');

  path = require('path');

  _ = require('underscore');

  module.exports = {
    load: function(options) {
      var all, package, vendor;
      package = stitch.createPackage({
        paths: options.paths,
        compilers: {
          jade: function(module, filename) {
            var source;
            source = fs.readFileSync(filename, 'utf8');
            source = "module.exports = " + jade.compile(source, {
              compileDebug: false,
              client: true
            }) + ";";
            return module._compile(source, filename);
          }
        },
        dependencies: options.dependencies
      });
      stitch = function() {
        return fs.mkdir('public/javascripts', function() {
          return package.compile(function(err, source) {
            return fs.writeFile(options.output.app, source, function(err) {
              if (err) throw err;
              return console.log("Compiled " + options.output.app);
            });
          });
        });
      };
      vendor = function() {
        return fs.mkdir(options.output.vendor, function() {
          var destination, inputStream, name, outputStream, source, _i, _len, _ref, _results;
          _ref = options.vendorDependencies;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            source = _ref[_i];
            name = path.basename(source);
            destination = [options.output.vendor, name].join('/');
            inputStream = fs.createReadStream(source);
            outputStream = fs.createWriteStream(destination);
            _results.push(util.pump(inputStream, outputStream, function(err) {
              if (err) throw err;
              return console.log("copied " + source + " to " + destination);
            }));
          }
          return _results;
        });
      };
      all = function() {
        stitch();
        return vendor();
      };
      return {
        stitch: stitch,
        vendor: vendor,
        all: all
      };
    }
  };

}).call(this);
