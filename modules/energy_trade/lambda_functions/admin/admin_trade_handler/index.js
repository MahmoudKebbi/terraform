// admin_trade_handler.js
const AWS = require("aws-sdk");
const dynamoDB = new AWS.DynamoDB.DocumentClient();

const TABLE_NAME = process.env.DYNAMODB_TABLE;

exports.handler = async (event) => {
  console.log("Admin API Event:", JSON.stringify(event));
  const httpMethod = event.requestContext.http.method;
  const path = event.requestContext.http.path;

  try {
    const senderGroups =
      event.requestContext.authorizer.claims["cognito:groups"] || [];

    if (!senderGroups.includes("Admins")) {
      return {
        statusCode: 403,
        body: JSON.stringify({ error: "Forbidden: User is not an admin" }),
      };
    }

    if (httpMethod === "GET") {
      if (event.pathParameters && event.pathParameters.trade_id) {
        return await getTrade(event.pathParameters.trade_id);
      } else {
        return await getTradeHistory(event);
      }
    } else if (
      httpMethod === "DELETE" &&
      event.pathParameters &&
      event.pathParameters.trade_id
    ) {
      return await deleteTrade(event.pathParameters.trade_id);
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Invalid admin request" }),
      };
    }
  } catch (err) {
    console.error("Error in Admin API:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Internal Server Error" }),
    };
  }
};

async function getTrade(trade_id) {
  const result = await dynamoDB
    .get({ TableName: TABLE_NAME, Key: { trade_id } })
    .promise();
  if (!result.Item) {
    return {
      statusCode: 404,
      body: JSON.stringify({ error: "Trade not found" }),
    };
  }
  return { statusCode: 200, body: JSON.stringify(result.Item) };
}

async function getTradeHistory(event) {
  const params = event.queryStringParameters || {};
  const limit = params.limit ? parseInt(params.limit) : 10;
  const lastKey = params.lastKey
    ? JSON.parse(decodeURIComponent(params.lastKey))
    : null;
  const userFilter = params.user_id; // Optional: filter by a specific user

  let scanParams = {
    TableName: TABLE_NAME,
    Limit: limit,
    ExclusiveStartKey: lastKey,
  };

  if (userFilter) {
    scanParams.FilterExpression = "buyer_id = :userId OR seller_id = :userId";
    scanParams.ExpressionAttributeValues = { ":userId": userFilter };
  }

  const result = await dynamoDB.scan(scanParams).promise();
  return {
    statusCode: 200,
    body: JSON.stringify({
      items: result.Items,
      lastKey: result.LastEvaluatedKey
        ? encodeURIComponent(JSON.stringify(result.LastEvaluatedKey))
        : null,
    }),
  };
}

async function deleteTrade(trade_id) {
  await dynamoDB.delete({ TableName: TABLE_NAME, Key: { trade_id } }).promise();
  return {
    statusCode: 200,
    body: JSON.stringify({ message: `Trade ${trade_id} deleted` }),
  };
}
