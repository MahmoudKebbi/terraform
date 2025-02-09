const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();
const tableName = process.env.TABLE_NAME;
const usernameIndex = process.env.USERNAME_INDEX; // Add the GSI name as an environment variable

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  if (!tableName || !usernameIndex) {
    console.error(
      "Environment variables TABLE_NAME or USERNAME_INDEX are not set"
    );
    return {
      statusCode: 500,
      body: JSON.stringify({
        message:
          "Environment variables TABLE_NAME or USERNAME_INDEX are not set",
      }),
    };
  }

  const usernameToGet = event.pathParameters.username; // Assuming username is passed as a path parameter
  console.log("usernameToGet:", usernameToGet);

  try {
    const params = {
      TableName: tableName,
      IndexName: usernameIndex, // Use the GSI
      KeyConditionExpression: "username = :username",
      ExpressionAttributeValues: {
        ":username": usernameToGet,
      },
    };

    console.log(
      "Querying DynamoDB with params:",
      JSON.stringify(params, null, 2)
    );
    const result = await dynamodb.query(params).promise();
    console.log("Query result:", JSON.stringify(result, null, 2));

    if (result.Items.length === 0) {
      console.error("User not found for username:", usernameToGet);
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    console.log("User found:", JSON.stringify(result.Items[0], null, 2));
    return {
      statusCode: 200,
      body: JSON.stringify(result.Items[0]),
    };
  } catch (error) {
    console.error("Error querying DynamoDB:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Internal server error",
        error: error.message,
      }),
    };
  }
};
