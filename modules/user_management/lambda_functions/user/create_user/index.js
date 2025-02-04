const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {
  const cognitoUsername =
    event.requestContext.authorizer.claims["cognito:username"];
  const usernameFromPath = event.pathParameters.username;

  if (usernameFromPath !== cognitoUsername) {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: "Forbidden" }),
    };
  }

  const {
    username,
    first_name,
    last_name,
    email,
    phone_number,
    street,
    city,
    province_state,
  } = JSON.parse(event.body);

  const params = {
    TableName: TABLE_NAME,
    Item: {
      username,
      first_name,
      last_name,
      email,
      phone_number,
      street,
      city,
      province_state,
    },
  };

  try {
    await dynamoDb.put(params).promise();
    return {
      statusCode: 201,
      body: JSON.stringify({ message: "User created successfully" }),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to create user", error }),
    };
  }
};
