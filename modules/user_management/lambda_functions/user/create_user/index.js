const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  if (!TABLE_NAME) {
    console.error("TABLE_NAME environment variable is not set");
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "TABLE_NAME environment variable is not set",
      }),
    };
  }

  let userData;
  try {
    userData = JSON.parse(event.body);
  } catch (error) {
    console.error("Error parsing request body:", error);
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: "Invalid request body",
        error: error.message,
      }),
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
  } = userData;

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
    console.log("User created successfully:", username);
    return {
      statusCode: 201,
      body: JSON.stringify({ message: "User created successfully" }),
    };
  } catch (error) {
    console.error("Error creating user:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to create user",
        error: error.message,
      }),
    };
  }
};
