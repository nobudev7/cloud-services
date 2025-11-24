package com.nobudev7;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayProxyResponseEvent;

import java.util.Map;

public class WhoAmI implements RequestHandler<Map<String, String>, APIGatewayProxyResponseEvent>{
    @Override
    public APIGatewayProxyResponseEvent handleRequest(Map<String, String> request, Context context) {
        APIGatewayProxyResponseEvent response = new APIGatewayProxyResponseEvent();

        String input_value = request.get("input_value");
        String responseBody;
        int statusCode;

        if (input_value == null) {
            responseBody = "You entered an incorrect name: " + "<null>";
            statusCode = 300;
        } else if ("MyNickName".compareToIgnoreCase(input_value) == 0 || "MyFirstName".compareToIgnoreCase(input_value) == 0) {
            responseBody = "You entered your first name";
            statusCode = 200;
        } else if ("MyLastName".compareToIgnoreCase(input_value) == 0) {
            responseBody = "You entered your last name}";
            statusCode = 200;
        } else {
            responseBody = "You entered an incorrect name: " + input_value;
            statusCode = 300;
        }

        return response
                .withStatusCode(statusCode)
                .withBody(responseBody);
    }
}
