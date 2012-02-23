(function() {
  var fs, jade, path, stitch, util, _;

  stitch = require('stitch');

  jade = require('jade');

  fs = require('fs');

  util = require('util');

  path = require('path');

  _ = require('underscore');

  module.exports = {
    load: function(root, options) {
      var all, dependencies, output, package, paths, vendor, vendorDependencies, _ref;
      _ref = this.loadOptions(root, options), output = _ref.output, paths = _ref.paths, dependencies = _ref.dependencies, vendorDependencies = _ref.vendorDependencies;
      package = stitch.createPackage({
        paths: paths,
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
        dependencies: dependencies
      });
      stitch = function() {
        return fs.mkdir('public/javascripts', function() {
          return package.compile(function(err, source) {
            return fs.writeFile(output.app, source, function(err) {
              if (err) throw err;
              return console.log("Compiled " + output.app);
            });
          });
        });
      };
      vendor = function() {
        return fs.mkdir(output.vendor, function() {
          var source, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = vendorDependencies.length; _i < _len; _i++) {
            source = vendorDependencies[_i];
            _results.push((function(source) {
              var destination, inputStream, name, outputStream;
              name = path.basename(source);
              destination = [output.vendor, name].join('/');
              inputStream = fs.createReadStream(source);
              outputStream = fs.createWriteStream(destination);
              return util.pump(inputStream, outputStream, function(err) {
                if (err) throw err;
                return console.log("copied " + source + " to " + destination);
              });
            })(source));
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
    },
    loadOptions: function(root, options) {
      var array, defaults, field, item, jointOptions, moduleNames, modulePath, name, package, trabianPackage, _i, _j, _k, _len, _len2, _len3, _ref;
      defaults = {
        paths: [],
        dependencies: [],
        vendorDependencies: []
      };
      jointOptions = _.extend(defaults, options.trabianPackage);
      moduleNames = _.union(_.flatten([_.keys(options.dependencies), _.keys(options.devDependencies)]));
      for (_i = 0, _len = moduleNames.length; _i < _len; _i++) {
        name = moduleNames[_i];
        modulePath = "node_modules/" + name;
        package = require("" + root + "/" + modulePath + "/package");
        if (trabianPackage = package.trabianPackage) {
          _ref = ['paths', 'dependencies', 'vendorDependencies'];
          for (_j = 0, _len2 = _ref.length; _j < _len2; _j++) {
            field = _ref[_j];
            if (array = trabianPackage[field]) {
              for (_k = 0, _len3 = array.length; _k < _len3; _k++) {
                item = array[_k];
                jointOptions[field].push([modulePath, item].join('/'));
              }
            }
          }
        }
      }
      return jointOptions;
    }
  };

}).call(this);
