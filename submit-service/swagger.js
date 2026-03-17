const swaggerJsdoc = require("swagger-jsdoc");

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "Submit Joke API",
      version: "1.0.0",
      description: "API for submitting jokes into the moderation pipeline",
    },
    servers: [
      {
        url: "https://zulq-jokes-kong.centralindia.cloudapp.azure.com/",
      },
    ],
  },
  apis: ["./server.js"],
};

const swaggerSpec = swaggerJsdoc(options);

module.exports = swaggerSpec;
