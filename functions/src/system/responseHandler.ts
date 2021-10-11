
// Small helper class to define structure of http responses.

export class ResponseHandler {
  // Return objects
  static returnError(errorMessage: string) {
    return {
      data: null,
      error: {
        message: errorMessage,
        errorObject: null,
      },
    };
  }

    // Return objects
    static returnErrorObject(errorMessage: string, errorObject: any) {
      return {
        data: null,
        error: {
          message: errorMessage,
          errorObject: errorObject,
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
