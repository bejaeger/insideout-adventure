
// Small helper class to define structure of http responses.

export class ResponseHandler {
  // Return objects
  static returnError(errorMessage: string) {
    return {
      data: null,
      error: {
        message: errorMessage,
      },
    };
  }

  static returnData(data: any) {
    return {
      data: data,
      error: null,
    };
  }

  static returnSuccess() {
    return {
      data: null,
      error: null,
    };
  }
}
