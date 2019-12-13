// See: jestjs.io/docs/configuration.html
module.exports = {
  "rootDir": "../../..",
  "roots": [
    "app/frontend/javascript",
    "spec/frontend/javascript"
  ],
  "moduleFileExtensions": [
    "js",
    "jsx"
  ],
  "moduleDirectories": [
    "node_modules",
    "app/frontend/javascript",
    "spec/frontend/javascript"
  ],
  "setupFilesAfterEnv": [
    "<rootDir>/spec/frontend/javascript/jest.setup.js"
  ],
  "transform": {
    "\\.jsx?$": "babel-jest"
  },
  "verbose": false
};
