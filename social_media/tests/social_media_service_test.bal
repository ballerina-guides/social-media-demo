// Copyright (c) 2023, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/test;
import ballerina/http;
import ballerinax/mysql;

@test:Mock {
    functionName: "initDbClient"
}
function mockInitDbClient() returns mysql:Client|error {
    return test:mock(mysql:Client);
}

@test:Config{}
public function testSentimentAnalysis() returns error? {
    User userExpected = { id: 999, name: "foo", birthDate: {year: 0, month: 0, day: 0}, mobileNumber: "1234567890"};
    test:prepare(socialMediaDb).when("queryRow").thenReturn(userExpected);

    http:Client socialMediaEndpoint = check new("localhost:9090/social-media");
    User userActual = check socialMediaEndpoint->/users/[userExpected.id.toString()];

    test:assertEquals(userActual, userExpected);
}
