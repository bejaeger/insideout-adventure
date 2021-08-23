// To be able to test the function with postman we wrap this
// in a try/catch block. Postman already parses the payload.
export function getPayload(body: any) {
  let data: any;
  try {
    data = JSON.parse(body);
  } catch (e) {
    data = body;
  }
  return data;
}
