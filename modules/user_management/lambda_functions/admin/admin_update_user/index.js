const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const cognito = new AWS.CognitoIdentityServiceProvider();
const TABLE_NAME = process.env.TABLE_NAME;
const USER_POOL_ID = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  const adminUsername =
    event.requestContext.authorizer.claims["cognito:username"];
  const usernameFromPath = event.pathParameters.username;

  try {
    // Check if the user is in the "Admins" group
    const adminGroups = await cognito
      .adminListGroupsForUser({
        UserPoolId: USER_POOL_ID,
        Username: adminUsername,
      })
      .promise();

    const isAdmin = adminGroups.Groups.some(
      (group) => group.GroupName === "Admins"
    );

    if (!isAdmin) {
      return {
        statusCode: 403,
        body: JSON.stringify({
          message: "User is not authorized to update user details",
        }),
      };
    }

    // Get the user_id from DynamoDB using the username
    const queryParams = {
      TableName: TABLE_NAME,
      IndexName: "username-index", // Assuming you have a GSI on the username attribute
      KeyConditionExpression: "username = :username",
      ExpressionAttributeValues: {
        ":username": usernameFromPath,
      },
    };

    const queryResult = await dynamoDb.query(queryParams).promise();
    if (queryResult.Items.length === 0) {
      return {
        statusCode: 404,
        body: JSON.stringify({ message: "User not found" }),
      };
    }

    const user_id = queryResult.Items[0].user_id; // Assuming the primary key is named 'user_id'

    const {
      first_name,
      last_name,
      email,
      phone_number,
      street,
      city,
      province_state,
    } = JSON.parse(event.body);

    let updateExpression = "set";
    let expressionAttributeValues = {};

    if (first_name) {
      updateExpression += " first_name = :first_name,";
      expressionAttributeValues[":first_name"] = first_name;
    }
    if (last_name) {
      updateExpression += " last_name = :last_name,";
      expressionAttributeValues[":last_name"] = last_name;
    }
    if (email) {
      updateExpression += " email = :email,";
      expressionAttributeValues[":email"] = email;
    }
    if (phone_number) {
      updateExpression += " phone_number = :phone_number,";
      expressionAttributeValues[":phone_number"] = phone_number;
    }
    if (street) {
      updateExpression += " street = :street,";
      expressionAttributeValues[":street"] = street;
    }
    if (city) {
      updateExpression += " city = :city,";
      expressionAttributeValues[":city"] = city;
    }
    if (province_state) {
      updateExpression += " province_state = :province_state,";
      expressionAttributeValues[":province_state"] = province_state;
    }

    // Remove the trailing comma
    updateExpression = updateExpression.slice(0, -1);

    const params = {
      TableName: TABLE_NAME,
      Key: { user_id },
      UpdateExpression: updateExpression,
      ExpressionAttributeValues: expressionAttributeValues,
      ReturnValues: "UPDATED_NEW",
    };

    // Update the user in DynamoDB
    const { Attributes } = await dynamoDb.update(params).promise();

    // Update the user attributes in Cognito User Pool
    const cognitoParams = {
      UserPoolId: USER_POOL_ID,
      Username: usernameFromPath,
      UserAttributes: [],
    };

    if (email) {
      cognitoParams.UserAttributes.push({
        Name: "email",
        Value: email,
      });
    }
    if (phone_number) {
      cognitoParams.UserAttributes.push({
        Name: "phone_number",
        Value: phone_number,
      });
    }

    if (cognitoParams.UserAttributes.length > 0) {
      await cognito.adminUpdateUserAttributes(cognitoParams).promise();
    }

    return {
      statusCode: 200,
      body: JSON.stringify(Attributes),
    };
  } catch (error) {
    console.error(error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to update user",
        error: error.message,
      }),
    };
  }
};
