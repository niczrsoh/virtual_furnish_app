/* eslint-disable no-undef */
/* eslint-disable max-len */
/* eslint-disable no-unused-vars */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const stripe = require("stripe")("sk_test_51P7EP6Dw8iLZtBO8RsiUsGVeuyt973YOu5PF8QDuql5weWrEFraedgdqZcPtVVkYZsABA1KNG1TNhzfCM3nXNtfl00QLz4v9vF");

const calculateOrderAmount = (items) => {
  prices = [];
  catalog = [
    {"id": "0", "price": 2.99},
    {"id": "1", "price": 3.99},
    {"id": "2", "price": 4.99},
    {"id": "3", "price": 5.99},
    {"id": "4", "price": 6.99},
  ];
  items.forEach((item) => {
    price = catalog.find((x) => x.id === item.id).price;
    prices.push(price);
  });
  return parseInt(prices.reduce((a, b) => a + b) * 100);
};
const generateResponse = function(intent) {
  switch (intent.status) {
    case "requires_action":
      return {
        clientSecret: intent.clientSecret,
        requiresAction: true,
        status: intent.status,
      };
    case "requires_payment_method":
      return {
        error: "Your card was denied, please provide a new payment method",
      };
    case "succeeded":
      return {
        clientSecret: intent.clientSecret,
        status: intent.status,
      };
  }
  return {
    error: "Unknown status",
  };
};
// eslint-disable-next-line max-len
exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res)=> {
  const {paymentMethodId, items, currency, useStripeSdk} = req.body;
  const orderAmount = calculateOrderAmount(items);

  try {
    if (paymentMethodId) {
      const param = {
        amount: orderAmount,
        currency: currency,
        payment_method: paymentMethodId,
        confirmation_method: "manual",
        confirm: true,
        use_stripe_sdk: useStripeSdk,
      };
      const intent = await stripe.paymentIntents.create(param);
      console.log("💰 PaymentIntent created: ", {intent});
      return res.send(generateResponse(intent));
    }
    return res.sendStatus(400);
  } catch (e) {
    console.log(e);
    return res.send({error: e.message});
  }
});

exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res)=> {
  const {paymentIntentId} = req.body;
  try {
    if (paymentIntentId) {
      const intent = await stripe.paymentIntents.confirm(paymentIntentId);
      console.log("💰 PaymentIntent confirmed: ", {intent});
      return res.send(generateResponse(intent));
    }
  } catch (e) {
    console.log(e);
    return res.send({error: e.message});
  }
});
