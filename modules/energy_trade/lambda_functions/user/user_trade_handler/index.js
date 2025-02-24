// user_trade_handler.js
const AWS = require("aws-sdk");
const dynamoDB = new AWS.DynamoDB.DocumentClient();

// Environment variables
const TABLE_NAME = process.env.DYNAMODB_TABLE;

exports.handler = async (event) => {
  console.log("User API Event:", JSON.stringify(event));
  const httpMethod = event.requestContext.http.method;
  const path = event.requestContext.http.path;
  const username = event.requestContext.authorizer.claims['cognito:username'];

  try {
    if (httpMethod === "POST" && path === "/trades") {
      const data = JSON.parse(event.body);
      return await createTrade(data);
    } else if (httpMethod === "GET") {
      if (event.pathParameters && event.pathParameters.trade_id) {
        return await getTrade(event.pathParameters.trade_id, username);
      } else {
        return await getTradeHistory(event);
      }
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify({ error: "Invalid request" }),
      };
    }
  } catch (err) {
    console.error("Error in User API:", err);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: "Internal Server Error" }),
    };
  }
};

async function createTrade(data) {
  // Save the trade record to DynamoDB
  await dynamoDB.put({ TableName: TABLE_NAME, Item: data }).promise();

  return {
    statusCode: 201,
    body: JSON.stringify({ message: "Trade recorded", trade: data }),
  };
}

async function getTrade(trade_id, username) {
  const result = await dynamoDB
    .get({ TableName: TABLE_NAME, Key: { trade_id } })
    .promise();
  if (!result.Item) {
    return {
      statusCode: 404,
      body: JSON.stringify({ error: "Trade not found" }),
    };
  }

  const trade = result.Item;
  if (trade.seller_username !== username && trade.buyer_username !== username) {
    return {
      statusCode: 403,
      body: JSON.stringify({
        error: "Forbidden: You are not authorized to view this trade",
      }),
    };
  }

  return { statusCode: 200, body: JSON.stringify(trade) };
}

async function getTradeHistory(event) {
  const params = event.queryStringParameters || {};
  const limit = params.limit ? parseInt(params.limit) : 10;
  const lastKey = params.lastKey
    ? JSON.parse(decodeURIComponent(params.lastKey))
    : null;

  // Extract filter parameters
  const buyer = params.buyer;
  const seller = params.seller;
  const startDate = params.startDate ? new Date(params.startDate) : null;
  const endDate = params.endDate ? new Date(params.endDate) : null;
  const minPrice = params.minPrice ? parseFloat(params.minPrice) : null;
  const maxPrice = params.maxPrice ? parseFloat(params.maxPrice) : null;
  const username = event.requestContext.authorizer.claims['cognito:username'];
  // Build the filter expression
  let filterExpression =
    "(buyer_username = :username OR seller_username = :username)";
  let expressionAttributeValues = { ":username": username };

  if (buyer) {
    filterExpression += " AND buyer_username = :buyer";
    expressionAttributeValues[":buyer"] = buyer;
  }

  if (seller) {
    filterExpression += " AND seller_username = :seller";
    expressionAttributeValues[":seller"] = seller;
  }

  if (startDate) {
    filterExpression += " AND trade_date >= :startDate";
    expressionAttributeValues[":startDate"] = startDate.toISOString();
  }

  if (endDate) {
    filterExpression += " AND trade_date <= :endDate";
    expressionAttributeValues[":endDate"] = endDate.toISOString();
  }

  if (minPrice) {
    filterExpression += " AND price >= :minPrice";
    expressionAttributeValues[":minPrice"] = minPrice;
  }

  if (maxPrice) {
    filterExpression += " AND price <= :maxPrice";
    expressionAttributeValues[":maxPrice"] = maxPrice;
  }

  // In production, use a Query on a GSI with a sort key for ordering by timestamp.
  const scanParams = {
    TableName: TABLE_NAME,
    Limit: limit,
    ExclusiveStartKey: lastKey,
    FilterExpression: filterExpression,
    ExpressionAttributeValues: expressionAttributeValues,
  };

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
