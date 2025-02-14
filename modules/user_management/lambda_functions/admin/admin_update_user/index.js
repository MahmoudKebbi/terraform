const AWS = require("aws-sdk");
const dynamodb = new AWS.DynamoDB.DocumentClient();
const tableName = process.env.TABLE_NAME;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  // Check if environment variables are set
  if (!tableName) {
    console.error(
      "Environment variables TABLE_NAME are not set"
    );
    return {
      statusCode: 500,
      body: JSON.stringify({
        message:
          "Environment variables TABLE_NAME are not set",
      }),
    };
  }

  let userDetails;
  try {
    userDetails = JSON.parse(event.body);
    console.log("User details to be updated:", userDetails);
  } catch (parseError) {
    console.error("Error parsing event body:", parseError);
    return {
      statusCode: 400,
      body: JSON.stringify({
        error: "Invalid request body",
        details: parseError.message,
      }),
    };
  }

  const usernameToUpdate = event.pathParameters.username; // Assuming username is passed as a path parameter
  console.log("usernameToUpdate:", usernameToUpdate);

  const senderGroups = event.requestContext.authorizer.claims["cognito:groups"];
  console.log("Sender groups:", senderGroups);

  // Check if the sender is in the Admins group
  if (!senderGroups.includes("Admins")) {
    console.warn("Access denied: sender is not in Admins group");
    return {
      statusCode: 403,
      body: JSON.stringify({
        error: "Access denied",
        message: "You must be an admin to perform this action",
      }),
    };
  }

  try {
    const params = {
      TableName: tableName,
      IndexName: usernameIndex, // Use the GSI
      KeyConditionExpression: "username = :username",
      ExpressionAttributeValues: {
        ":username": usernameToUpdate,
      },
    };

    console.log(
      "Querying DynamoDB with params:",
      JSON.stringify(params, null, 2)
    );
    const queryResult = await dynamodb.query(params).promise();
    console.log("Query result:", JSON.stringify(queryResult, null, 2));

    if (queryResult.Items.length === 0) {
      console.error("User not found for username:", usernameToUpdate);
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    const user_id = queryResult.Items[0].user_id; // Assuming the primary key is named 'user_id'

    const updateParams = {
      TableName: tableName,
      Key: { user_id: user_id },
      UpdateExpression:
        "set #firstName = :firstName, #lastName = :lastName, #email = :email, #phoneNumber = :phoneNumber",
      ExpressionAttributeNames: {
        "#firstName": "first_name",
        "#lastName": "last_name",
        "#email": "email",
        "#phoneNumber": "phone_number",
      },
      ExpressionAttributeValues: {
        ":firstName": userDetails.first_name,
        ":lastName": userDetails.last_name,
        ":email": userDetails.email,
        ":phoneNumber": userDetails.phone_number,
      },
      ReturnValues: "UPDATED_NEW",
    };

    console.log(
      "Updating DynamoDB with params:",
      JSON.stringify(updateParams, null, 2)
    );
    const updateResult = await dynamodb.update(updateParams).promise();
    console.log("Update result:", JSON.stringify(updateResult, null, 2));

    return {
      statusCode: 200,
      body: JSON.stringify({
        message: "User updated successfully",
        updatedAttributes: updateResult.Attributes,
      }),
    };
  } catch (error) {
    console.error("Error updating user:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Internal server error",
        error: error.message,
      }),
    };
  }
};
