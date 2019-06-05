// See: jestjs.io/docs/configuration.html
module.exports = {
  "rootDir": "../../",
  "roots": [
    "app/javascript",
    "spec/javascript"
  ],
  "moduleFileExtensions": [
    "js",
    "jsx"
  ],
  "moduleDirectories": [
    "node_modules",
    "app/javascript",
    "spec/javascript"
  ],
  "setupFilesAfterEnv": [
    "<rootDir>/spec/javascript/jest.setup.js"
  ],
  "transform": {
    "\\.jsx?$": "babel-jest"
  },
  "verbose": false
};
