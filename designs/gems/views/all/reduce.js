function Part(token) {
  this.token = token;

  this.is_alpha = function() {
    return(isNaN(parseInt(this.token)));
  }

  this.is_numeric = function() {
    return(!isNaN(parseInt(this.token)));
  }

  this.sort_against = function(other) {
    if (this.is_numeric() && other.is_alpha()) { return(1);  }
    if (this.is_alpha() && other.is_numeric()) { return(-1); }
    if (this.token == other.token)             { return(0);  }

    return((this.token < other.token) ? -1 : 1);
  }

  this.toString = function() {
    return(this.token);
  }
}

function Version(number) {
  this.number = number;

  this.to_parts = function() {
    var parts = this.number.match(/[0-9a-z]+/ig);
    var part_objects = [];

    for (var idx in parts) {
      part_objects.push(new Part(parts[idx]));
    }

    return(part_objects);
  }

  this.sort_against = function(other) {
    var self_parts  = this.to_parts();
    var other_parts = other.to_parts();

    // balance
    while (self_parts.length < other_parts.length) { self_parts.push(new Part('0')); }
    while (other_parts.length < self_parts.length) { other_parts.push(new Part('0')); }

    var sort = 0;
    var idx  = 0;

    while (sort == 0 && idx < self_parts.length) {
      sort = self_parts[idx].sort_against(other_parts[idx]);
      idx++;
    }

    return(sort);
  }
}

function(key, values) {

  var sorted = values.sort(function(a, b) {
    var version_a = new Version(a.version);
    var version_b = new Version(b.version);
    var sort = version_b.sort_against(version_a);

    if (sort == 0) {
      if (version_a.updated_at == version_b.updated_at) { sort = 0; }
      sort = (version_b.updated_at > version_a.updated_at) ? -1 : 1;
    }

    return (sort);
  });

  return({
    _id:        sorted[0]._id,
    name:       sorted[0].name,
    version:    sorted[0].version,
    updated_at: sorted[0].updated_at
  });
}
