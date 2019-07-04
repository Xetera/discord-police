"use strict";

const fs = require("fs");

// stupid purs only lets me use ES5
exports._readDir = function(path) {
  return function(err, success) {
    fs.readdir(path, { withFileTypes: true }, function(error, paths) {
      if (error) {
        return err(error);
      }
      const files = paths.map(function(path) {
        return {
          fileType: path.isDirectory() ? "Folder" : "File",
          name: path.name
        };
      });
      return success(files);
    });
  };
};
