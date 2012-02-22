
  Backbone.View.prototype._originalConfigure = Backbone.View.prototype._configure;

  _.extend(Backbone.View.prototype, {
    _configure: function(options) {
      this._originalConfigure(options);
      this.controller = options.controller;
    },
    bindTo: function(source, event, callback) {
      var _ref;
      if ((_ref = this.bindings) == null) this.bindings = [];
      source.on(event, callback, this);
      return this.bindings.push({
        source: source,
        event: event,
        callback: callback
      });
    },
    unbindFromAll: function() {
      var binding, _i, _len, _ref, _results;
      if (this.bindings != null) {
        _ref = this.bindings;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          binding = _ref[_i];
          _results.push(binding.source.unbind(binding.event, binding.callback));
        }
        return _results;
      }
    },
    leave: function() {
      return this.unbindFromAll();
    }
  });
