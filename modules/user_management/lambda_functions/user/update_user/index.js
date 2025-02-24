const AWS = require("aws-sdk");
const dynamoDb = new AWS.DynamoDB.DocumentClient();
const cognito = new AWS.CognitoIdentityServiceProvider();
const TABLE_NAME = process.env.TABLE_NAME;
const USER_POOL_ID = process.env.USER_POOL_ID;

exports.handler = async (event) => {
  console.log("Received event:", JSON.stringify(event, null, 2));

  const usernameFromPath = event.pathParameters.username;
  console.log("usernameFromPath:", usernameFromPath);
  const userId = event.requestContext.authorizer.claims.sub;
  console.log("userId:", userId);

  const getUserParams = {
    TableName: TABLE_NAME,
    Key: { user_id: userId },
  };

  try {
    const { Item } = await dynamoDb.get(getUserParams).promise();
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

    const {
      first_name,
      last_name,
      email,
      phone_number,
      street,
      city,
      province_state,
      building,
      floor,
      apartment,
      web_3_wallet_address,
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
    if (building) {
      updateExpression += " building = :building,";
      expressionAttributeValues[":building"] = building;
    }
    if (floor) {
      updateExpression += " floor = :floor,";
      expressionAttributeValues[":floor"] = floor;
    }
    if (apartment) {
      updateExpression += " apartment = :apartment,";
      expressionAttributeValues[":apartment"] = apartment;
    }
    if (web_3_wallet_address) {
      updateExpression += " web_3_wallet_address = :web_3_wallet_address,";
      expressionAttributeValues[":web_3_wallet_address"] = web_3_wallet_address;
    }

    // Remove the trailing comma
    updateExpression = updateExpression.slice(0, -1);

    const params = {
      TableName: TABLE_NAME,
      Key: { user_id: userId },
      UpdateExpression: updateExpression,
      ExpressionAttributeValues: expressionAttributeValues,
      ReturnValues: "UPDATED_NEW",
    };

    // Update the user in DynamoDB
    const { Attributes } = await dynamoDb.update(params).promise();
    console.log(
      "User updated in DynamoDB:",
      JSON.stringify(Attributes, null, 2)
    );

    // Update the user attributes in Cognito User Pool
    const cognitoParams = {
      UserPoolId: USER_POOL_ID,
      Username: Item.username,
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
      console.log(
        "User attributes updated in Cognito User Pool:",
        JSON.stringify(cognitoParams.UserAttributes, null, 2)
      );
    }

    return {
      statusCode: 200,
      body: JSON.stringify(Attributes),
    };
  } catch (error) {
    console.error("Error updating user:", error);
    return {
      statusCode: 500,
      body: JSON.stringify({
        message: "Failed to update user",
        error: error.message,
      }),
    };
  }
};
