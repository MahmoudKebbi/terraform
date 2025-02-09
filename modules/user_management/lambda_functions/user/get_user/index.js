const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const TABLE_NAME = process.env.TABLE_NAME;

exports.handler = async (event) => {

  if (!TABLE_NAME) {
    console.error("TABLE_NAME environment variable is not set");
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Internal server error" }),
    };
  }
  
  console.log("Received event:", JSON.stringify(event, null, 2));

  const usernameFromPath = event.pathParameters.username;
  const userId = event.requestContext.authorizer.claims.sub;

  const params = {
    TableName: TABLE_NAME,
    Key: { user_id: userId },
  };

  try {
    const { Item } = await dynamoDb.get(params).promise();
    if (!Item) {
      console.error("User not found for user_id:", userId);
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    if (Item.username !== usernameFromPath) {
      console.error(
        "Username mismatch: path username:",
        usernameFromPath,
        "DB username:",
        Item.username
      );
      return {
        statusCode: 403,
        body: JSON.stringify({ message: "Forbidden" }),
      };
    }

    console.log("User found:", JSON.stringify(Item, null, 2));
    return {
      statusCode: 200,
      body: JSON.stringify(Item),
    };
  } catch (error) {
    console.error("Error fetching user:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: "Failed to get user", error }),
    };
  }
};
