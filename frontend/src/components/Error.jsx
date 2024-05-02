/**
 * Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

import React from "react";
import Box from "@mui/material/Box";
import ErrorOutlineIcon from '@mui/icons-material/ErrorOutline';

export default function Error({ errorMessage = "An error occurred!" }) {
    return (
        <Box
            sx={{
                display: "flex",
                flexDirection: "column",
                alignItems: "center",
                padding: "1rem",
            }}>
            <ErrorOutlineIcon
                fontSize="large" color="primary"
                sx={{
                    padding: "0.5rem 2rem",
                }}
            />
            <h1>{errorMessage}</h1>
            <p>Maybe this functionality is not implemented in the server</p>
        </Box>
    );
}
